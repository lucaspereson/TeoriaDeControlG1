TYPE
  LOGLEVEL : (CRITICAL, WARNING, INFO, DEBUG) := INFO;
END_TYPE

FUNCTION_BLOCK LOGGER
  VAR_INPUT
    TRIG : BOOL;
    MSG : STRING;
    LEVEL : LOGLEVEL := INFO;
  END_VAR
  VAR
    TRIG0 : BOOL;
  END_VAR

  IF TRIG AND NOT TRIG0 THEN
  {{
   LogMessage(GetFbVar(LEVEL),(char*)GetFbVar(MSG, .body),GetFbVar(MSG, .len));
  }}
  END_IF;
  TRIG0:=TRIG;
END_FUNCTION_BLOCK



FUNCTION_BLOCK python_eval
  VAR_INPUT
    TRIG : BOOL;
    CODE : STRING;
  END_VAR
  VAR_OUTPUT
    ACK : BOOL;
    RESULT : STRING;
  END_VAR
  VAR
    STATE : DWORD;
    BUFFER : STRING;
    PREBUFFER : STRING;
    TRIGM1 : BOOL;
    TRIGGED : BOOL;
  END_VAR

  {extern void __PythonEvalFB(int, PYTHON_EVAL*);__PythonEvalFB(0, data__);}
END_FUNCTION_BLOCK

FUNCTION_BLOCK python_poll
  VAR_INPUT
    TRIG : BOOL;
    CODE : STRING;
  END_VAR
  VAR_OUTPUT
    ACK : BOOL;
    RESULT : STRING;
  END_VAR
  VAR
    STATE : DWORD;
    BUFFER : STRING;
    PREBUFFER : STRING;
    TRIGM1 : BOOL;
    TRIGGED : BOOL;
  END_VAR

  {extern void __PythonEvalFB(int, PYTHON_EVAL*);__PythonEvalFB(1,(PYTHON_EVAL*)(void*)data__);}
END_FUNCTION_BLOCK

FUNCTION_BLOCK python_gear
  VAR_INPUT
    N : UINT;
    TRIG : BOOL;
    CODE : STRING;
  END_VAR
  VAR_OUTPUT
    ACK : BOOL;
    RESULT : STRING;
  END_VAR
  VAR
    py_eval : python_eval;
    COUNTER : UINT;
    _TMP_ADD10_OUT : UINT;
    _TMP_EQ13_OUT : BOOL;
    _TMP_SEL15_OUT : UINT;
    _TMP_AND7_OUT : BOOL;
  END_VAR

  _TMP_ADD10_OUT := ADD(COUNTER, 1);
  _TMP_EQ13_OUT := EQ(N, _TMP_ADD10_OUT);
  _TMP_SEL15_OUT := SEL(_TMP_EQ13_OUT, _TMP_ADD10_OUT, 0);
  COUNTER := _TMP_SEL15_OUT;
  _TMP_AND7_OUT := AND(_TMP_EQ13_OUT, TRIG);
  py_eval(TRIG := _TMP_AND7_OUT, CODE := CODE);
  ACK := py_eval.ACK;
  RESULT := py_eval.RESULT;
END_FUNCTION_BLOCK


PROGRAM program0
  VAR
    Sensor_Inc : BOOL;
    Luz_verde : BOOL;
    Luz_azul : BOOL;
    Luz_roja : BOOL;
  END_VAR
  VAR
    Retardo_LR : TIME := T#250ms;
    Retardo_LA : TIME := T#3s;
    TP0 : TP;
    TOF0 : TOF;
    TOF1 : TOF;
    CTU0 : CTU;
    _TMP_NOT2_OUT : BOOL;
    _TMP_NOT5_OUT : BOOL;
    _TMP_AND6_OUT : BOOL;
    _TMP_XOR35_OUT : BOOL;
    _TMP_NOT24_OUT : BOOL;
    _TMP_AND26_OUT : BOOL;
    R_TRIG1 : R_TRIG;
    _TMP_SEL42_OUT : BOOL;
  END_VAR

  _TMP_NOT2_OUT := NOT(Sensor_Inc);
  TOF1(IN := Sensor_Inc, PT := Retardo_LA);
  _TMP_NOT5_OUT := NOT(TOF1.Q);
  _TMP_AND6_OUT := AND(_TMP_NOT2_OUT, _TMP_NOT5_OUT);
  Luz_verde := _TMP_AND6_OUT;
  _TMP_XOR35_OUT := XOR(TOF1.Q, Sensor_Inc);
  Luz_azul := _TMP_XOR35_OUT;
  TOF0(IN := TP0.Q, PT := Retardo_LR);
  _TMP_NOT24_OUT := NOT(TOF0.Q);
  TP0(IN := _TMP_NOT24_OUT, PT := Retardo_LR);
  _TMP_AND26_OUT := AND(Sensor_Inc, TP0.Q);
  R_TRIG1(CLK := _TMP_AND26_OUT);
  CTU0(CU := R_TRIG1.Q, R := _TMP_NOT2_OUT, PV := 20);
  _TMP_SEL42_OUT := SEL(CTU0.Q, _TMP_AND26_OUT, CTU0.Q);
  Luz_roja := _TMP_SEL42_OUT;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : program0;
  END_RESOURCE
END_CONFIGURATION
