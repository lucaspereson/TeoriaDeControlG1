PROGRAM program0
  VAR
    Sensor_Inc AT %IX0.3 : BOOL;
    Luz_verde AT %QX0.1 : BOOL;
    Luz_azul AT %QX0.2 : BOOL;
    Luz_roja AT %QX0.0 : BOOL;
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
