#include "InterpolateInTimeFunction.h"

registerMooseObject("konstantinApp", InterpolateInTimeFunction);

InputParameters
InterpolateInTimeFunction::validParams()
{
  InputParameters params = Function::validParams();
  params.addClassDescription("Function tht performs a linear interpolation between given values "
                             "over time read from a file.");
  params.addRequiredParam<FileName>(
      "file_name", "The name of the file holding delimited data - time and value.");
  params.addParam<bool>("interpolate_in_time",
                        true,
                        "Whether or not to interpolate the values read from the time over time "
                        "during the simulation.");
  return params;
}

InterpolateInTimeFunction::InterpolateInTimeFunction(const InputParameters & parameters)
  : Function(parameters),
    _file_name(getParam<FileName>("file_name")),
    _interpolate_in_time(getParam<bool>("interpolate_in_time"))
{
  _time.clear();
  _value.clear();
  readFile();
}

void
InterpolateInTimeFunction::readFile()
{
  MooseUtils::checkFileReadable(_file_name);
  std::ifstream stream(_file_name);
  if (stream.peek() == std::ifstream::traits_type::eof())
    mooseError(name(), ": file [", _file_name, "] is empty, aborting.");
  if (!stream.good())
    mooseError(name(), ": error opening file [", _file_name, "], aborting.");
  std::string line;
  std::vector<double> vec_tmp;
  while (std::getline(stream, line))
  {
    if (line.empty() || line[0] == '#')
      continue;
    if (!MooseUtils::tokenizeAndConvert<double>(line, vec_tmp, delimiter(line)))
      mooseError(name(),
                 ": failed to convert while reading file [",
                 _file_name,
                 "] for line [",
                 line,
                 "].");
    _time.push_back(vec_tmp[0]);
    _value.push_back(vec_tmp[1]);
  }
  stream.close();
}

const std::string &
InterpolateInTimeFunction::delimiter(const std::string & line)
{
  if (_delimiter.empty())
  {
    if (line.find(",") != std::string::npos)
      _delimiter = ",";
    else if (line.find("\t") != std::string::npos)
      _delimiter = "\t";
    else if (line.find(";") != std::string::npos)
      _delimiter = ";";
    else
      _delimiter = " ";
  }
  return _delimiter;
}

Real
InterpolateInTimeFunction::value(Real t, const Point & /*pt*/) const
{
  Real v = 0.0;
  bool found = false;
  Real t_step;
  Real v_step;

  /*check time bounds*/
  if (t < _time[0])
    mooseError(name(),
               ": the initial time from the file should match the initial time of the simulation.");

  if (t >= _time[_time.size() - 1])
    return _value[_time.size() - 1];

  for (MooseIndex(_time.size()) i = 0; i < _time.size(); ++i)
  {
    if ((t >= _time[i] && t < _time[i + 1]))
    {
      if (t == _time[i])
        return _value[i];
      if (_interpolate_in_time)
      {
        t_step = _time[i + 1] - _time[i];
        if (t_step <= 0.0)
          mooseError(name(), ": time steps are not in increasing order, aborting.");
        v_step = _value[i + 1] - _value[i];
        v = _value[i + 1] - v_step * (_time[i + 1] - t) / t_step;
        found = true;
        break;
      }
      v = _value[i];
      found = true;
      break;
    }
  }
  if (!found)
    mooseError(name(), " function value at time ", t, " not found, aborting.");
  return v;
}
