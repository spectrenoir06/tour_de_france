#define LED_PIN 13
#define HALL1_PIN 2
#define HALL2_PIN 3

volatile uint16_t hall1_count = 0;
volatile uint16_t hall2_count = 0;


void hall1_int() {
	hall1_count++;
}

void hall2_int() {
	hall2_count++;
}

void setup() {
	Serial.begin(115200);

	pinMode(LED_PIN, OUTPUT);

	pinMode(HALL1_PIN, INPUT);
	digitalWrite(HALL1_PIN, HIGH);
	attachInterrupt(digitalPinToInterrupt(HALL1_PIN), hall1_int, RISING);

	pinMode(HALL2_PIN, INPUT);
	digitalWrite(HALL2_PIN, HIGH);
	attachInterrupt(digitalPinToInterrupt(HALL2_PIN), hall2_int, RISING);
}

void loop() {
	Serial.print(hall1_count);
	Serial.print(",");
	Serial.println(hall2_count);

	hall1_count = 0;
	hall2_count = 0;

	delay(1000);
}
