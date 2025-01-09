[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = ../models/cable.msh
  []
[]

[Variables]
  [./T]
    initial_condition = 293.0 #in K
  [../]
  [./elec]
  [../]
[]

[Kernels]
  [./HeatDiff]
    type = HeatConduction
    variable = T
  [../]
  [./HeatTdot]
    type = HeatConductionTimeDerivative
    variable = T
  [../]
  [./HeatSrc]
    type = JouleHeatingSource
    variable = T
    elec = elec
    save_in = var
  [../]
  [./electric]
    type = HeatConduction
    variable = elec
    diffusion_coefficient = electrical_conductivity
  [../]
[]

[AuxVariables]
  [var]
  []
  [elect_conduct]
    order = CONSTANT
    family = MONOMIAL
  []
[]
[AuxKernels]
  [elec_conduct_aux]
    type = MaterialRealAux
    variable = elect_conduct
    property = electrical_conductivity
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[BCs]
  [./lefttemp]
    type = DirichletBC
    boundary = 'sorce'
    variable = T
    value = 293 #in K
  [../]
  [./elec_left]
    type = DirichletBC
    variable = elec
    boundary = 'sorce'
    value = 1 #in V
  [../]
  [./elec_right]
    type = DirichletBC
    variable = elec
    boundary = 'conductor'
    value = 0
  [../]
  [flow_out_T]
    type = HeatConductionBC
    variable = T
    boundary = 'conductor'
  []
[]

[Materials]
  [./k]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '397.48' #copper in W/(m K)
    block = 'aluminium'
  [../]
  [./cp]
    type = GenericConstantMaterial
    prop_names = 'specific_heat'
    prop_values = '385.0' #copper in J/(kg K)
    block = 'aluminium'
  [../]
  [./rho]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '8920.0' #copper in kg/(m^3)
    block = 'aluminium'
  [../]
  [./sigma] #copper is default material
    type = ElectricalConductivity
    temperature = T
  [../]
#  [./sigma_const]
#    type = GenericConstantMaterial
#    prop_names = 'electrical_conductivity'
#    prop_values = '0.0265' #copper in kg/(m^3)
#    block = 'aluminium'
#  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -ksp_grmres_restart -sub_ksp_type -sub_pc_type -pc_asm_overlap'
  petsc_options_value = 'asm         101   preonly   ilu      1'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  l_tol = 1e-4
  dt = 5
  end_time = 3600
[]

[Outputs]
  exodus = true
  perf_graph = true
[]
