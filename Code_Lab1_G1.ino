#include <AccelStepper.h>

#define IN1 D0
#define IN2 D1
#define IN3 D2
#define IN4 D3
#define R D4
#define G D5
#define B D6
#define sensor_inc D7
#define eje_x A0

int valor_inc = 1;
int valor_x = 0;
AccelStepper motor(AccelStepper::HALF4WIRE, IN1, IN3, IN2, IN4);
const int stepsPerRevolution = 2048;
int velocidad_actual = 500;
int velocidad_apagado = 0;
String texto = "VEL";

void setup() {
  pinMode(R, OUTPUT);
  pinMode(G, OUTPUT);
  pinMode(B, OUTPUT);
  pinMode(eje_x, INPUT);
  pinMode(sensor_inc, INPUT);
  Serial.begin (115200);
  motor.setMaxSpeed(velocidad_actual);
  motor.setAcceleration(200);
  motor.move(stepsPerRevolution);
}

void loop() {
  //sensor de inclinacion
  valor_inc = digitalRead(sensor_inc);

  // sensor basculante biaxial
  valor_x = analogRead(eje_x);

  //plotter
  if (Serial.available()) {
    texto = Serial.readStringUntil('\n');
  };
  if (texto == "INC"){
    Serial.println(valor_inc);
  }
  else{
    if (valor_inc == 0){
      Serial.println(velocidad_actual);
    }
    else {
      Serial.println(velocidad_apagado);
    }
  }

  //motor
  if (valor_inc == 0){
    motor.run();
    motor.move(stepsPerRevolution);
  };

  //cambios de velocidad
  if (valor_x > 1000){
    if (velocidad_actual < 1000) {
      velocidad_actual = velocidad_actual + 100 ;
      motor.setMaxSpeed(velocidad_actual);
      digitalWrite(R, 0);
      digitalWrite(G, 2);
      digitalWrite(B, 0);
      delay(300);
      digitalWrite(R, 0);
      digitalWrite(G, 0);
      digitalWrite(B, 0);
    };
    if (velocidad_actual == 1000) {
      digitalWrite(R, 2);
      digitalWrite(G, 2);
      digitalWrite(B, 2);
    };
  }
  else{
    if (valor_x < 100){
      if (velocidad_actual > 0) {  
        velocidad_actual = velocidad_actual - 100;
        motor.setMaxSpeed(velocidad_actual);
        digitalWrite(R, 0);
        digitalWrite(G, 0);
        digitalWrite(B, 2);
        delay(300);
        digitalWrite(R, 0);
        digitalWrite(G, 0);
        digitalWrite(B, 0);
      };
      if (velocidad_actual == 0){
        digitalWrite(R, 2);
        digitalWrite(G, 0);
        digitalWrite(B, 0);
      };
    }
  }
}
