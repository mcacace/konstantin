#include "konstantinApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
konstantinApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

konstantinApp::konstantinApp(InputParameters parameters) : MooseApp(parameters)
{
  konstantinApp::registerAll(_factory, _action_factory, _syntax);
}

konstantinApp::~konstantinApp() {}

void
konstantinApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAllObjects<konstantinApp>(f, af, syntax);
  Registry::registerObjectsTo(f, {"konstantinApp"});
  Registry::registerActionsTo(af, {"konstantinApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
konstantinApp::registerApps()
{
  registerApp(konstantinApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
konstantinApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  konstantinApp::registerAll(f, af, s);
}
extern "C" void
konstantinApp__registerApps()
{
  konstantinApp::registerApps();
}
