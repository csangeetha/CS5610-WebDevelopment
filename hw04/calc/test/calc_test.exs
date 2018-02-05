defmodule CalcTest do
  use ExUnit.Case
  require Calc
  test "check calculator functions" do
    string_1="2 + 3"
    string_2="5 * 1"
    string_3="20 / 4"
    string_4="24 / 6 + (5 - 4)"
    string_5="1 + 3 * 3 + 1"
    assert Calc.eval(string_1) == 5
    assert Calc.eval(string_2) == 5
    assert Calc.eval(string_3) == 5
    assert Calc.eval(string_4) == 5
    assert Calc.eval(string_5) == 11
  end
end
