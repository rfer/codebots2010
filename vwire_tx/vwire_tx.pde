#include <VirtualWire.h>  // you must download and install the VirtualWire.h to your hardware/libraries folder
#undef int
#undef abs
#undef double
#undef float
#undef round

char *prefix = "LMR-I";

void setup()
{
     // Initialise the IO and ISR
    vw_set_ptt_inverted(true); // Required for RF Link module
    vw_setup(2000);                 // Bits per sec
    vw_set_tx_pin(8);                // pin 3 is used as the transmit data out into the TX Link module, change this to suit your needs. 

  Serial.begin(9600);
}

void loop()
{
    //const char *msg = "LMR-Ia";       // this is your message to send
    
    char buf[6];
    
    if (Serial.available() > 0) {
      
      char cena = (char)Serial.read();
      
      sprintf(buf, "%s%c", prefix, cena);
      
      const char *msg = (const char*) buf;
      
      //Serial.println(msg);
      
      vw_send((uint8_t *)msg, strlen(msg));
      vw_wait_tx();                                          // Wait for message to finish
      //delay(200);
    }
   
}
