#! /bin/sh

. ../../testenv.sh

analyze_failure --force-analysis inst1.vhdl
analyze_failure --force-analysis notype1.vhdl
analyze_failure --force-analysis notype2.vhdl
analyze_failure --force-analysis nochoice1.vhdl
analyze_failure --force-analysis nochoice2.vhdl
analyze_failure --force-analysis choicelen.vhdl
analyze_failure --force-analysis noexpr.vhdl 

if analyze_failure --force-analysis notype1.vhdl 2>&1 | grep -q "indexed name"; then
  :
else
  echo "FAIL: missing error message from semantic analysis"
fi

clean

echo "Test successful"
