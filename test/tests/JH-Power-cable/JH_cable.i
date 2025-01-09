[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = 'mesh/cable1.msh'
  []
[]

[Variables]
  [T]
    initial_condition = 293.0
  []
  [elec]
  []
[]

[Kernels]
  [HeatDiff]
    type = HeatConduction
    variable = T
  []
  [HeatTdot]
    type = HeatConductionTimeDerivative
    variable = T
  []
  [HeatSrc]
    type = JouleHeatingSource
    variable = T
    elec = elec
    save_in = var
  []
  [electric]
    type = HeatConduction
    variable = elec
    diffusion_coefficient = electrical_conductivity
  []
[]

[AuxVariables]
  [var]
  []
  [elec_cond]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [elec_cond_aux]
    type = MaterialRealAux
    property = electrical_conductivity
    variable = elec_cond
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[BCs]
  [elec_left]
    type = DirichletBC
    variable = elec
    boundary = 'source'
    value = 0.1 #in V
  []
  [elec_right]
    type = DirichletBC
    variable = elec
    boundary = 'conductor'
    value = 0
  []
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
  [k]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '397.48' #copper in W/(m K)
    block = 'aluminium'
  []
  [cp]
    type = GenericConstantMaterial
    prop_names = 'specific_heat'
    prop_values = '385.0' #copper in J/(kg K)
    block = 'aluminium'
  []
  [rho]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '8920.0' #copper in kg/(m^3)
    block = 'aluminium'
  []
  [sigma] #copper is default material
    type = ElectricalConductivity
    temperature = T
  []
[]

[Preconditioning]
  active = 'FSP'
  [SMP]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package
                           -snes_atol -snes_rtol
                           -ksp_rtol'
    petsc_options_value = 'lu  mumps
                          1e-8 1e-10
                          1e-10'
  []
  [FSP]
    type = FSP
    topsplit = 'HT'
    [HT]
      splitting = 'H T'
      splitting_type = MULTIPLICATIVE
      petsc_options_iname = '-snes_type -snes_linesearch_type
                            -snes_atol -snes_rtol -snes_max_it
                            -ksp_type
                            -ksp_rtol -ksp_max_it'
      petsc_options_value = 'newtonls basic
                             1e-8 1e-8 1000
                             fgmres
                             1e-8 100'
    []
    [H]
      vars = 'elec'
      petsc_options_iname = '-ksp_type
                              -pc_type -pc_hypre_type'
      petsc_options_value = 'preonly
                             hypre boomeramg'
    []
    [T]
      vars = 'T'
      petsc_options_iname = '-ksp_type
                              -pc_type -sub_pc_type -sub_pc_factor_levels
                              -ksp_rtol -ksp_max_it'
      petsc_options_value = 'fgmres
                             asm ilu 1
                             1e-4 500'
    []
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  dt = 5
  end_time = 300
  automatic_scaling = true
[]

[Outputs]
  print_linear_residuals = false
  exodus = true
  perf_graph = true
[]
