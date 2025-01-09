[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = cable1.msh
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
[]

[BCs]
  [./elec_left]
    type = DirichletBC
    variable = elec
    boundary = 'source'
    value = 0.1 #in V
  [../]
  [./elec_right]
    type = DirichletBC
    variable = elec
    boundary = 'conductor'
    value = 0
  [../]
  [temp]
    type = DirichletBC
    variable = T
    boundary = 'source'
    value = 293
  []
  [tout]
    type = HeatConductionBC
    boundary = 'conductor'
    variable = T
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
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = ' lu       mumps'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10
  dt = 5
  end_time = 300
 automatic_scaling = true
[]

[Outputs]
  exodus = true
  perf_graph = true
[]
