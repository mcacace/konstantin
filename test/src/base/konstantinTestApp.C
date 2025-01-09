//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "konstantinTestApp.h"
#include "konstantinApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

InputParameters
konstantinTestApp::validParams()
{
  InputParameters params = konstantinApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

konstantinTestApp::konstantinTestApp(InputParameters parameters) : MooseApp(parameters)
{
  konstantinTestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

konstantinTestApp::~konstantinTestApp() {}

void
konstantinTestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  konstantinApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"konstantinTestApp"});
    Registry::registerActionsTo(af, {"konstantinTestApp"});
  }
}

void
konstantinTestApp::registerApps()
{
  registerApp(konstantinApp);
  registerApp(konstantinTestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
konstantinTestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  konstantinTestApp::registerAll(f, af, s);
}
extern "C" void
konstantinTestApp__registerApps()
{
  konstantinTestApp::registerApps();
}
