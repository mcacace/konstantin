#include "Function.h"

class InterpolateInTimeFunction : public Function
{
public:
  static InputParameters validParams();
  InterpolateInTimeFunction(const InputParameters & parameters);
  virtual Real value(Real t, const Point & pt) const override;

protected:
  const FileName _file_name;
  std::string _delimiter;
  std::vector<Real> _time;
  std::vector<Real> _value;

  const bool _interpolate_in_time;

private:
  void readFile();
  const std::string & delimiter(const std::string & line);
};
