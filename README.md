# CRC
## specifications       
1. All registers are set to LFSR Seed value using asynchronous active 
low reset (SEED = 8'hD8)        
3. All outputs are registered        
4. DATA serial bit length vary from 1 byte to 4 bytes (Typically: 1 Byte)        
5. ACTIVE input signal is high during data transmission, low otherwise        
6. CRC 8 bits are shifted serially through CRC output port         
7. Valid signal is high during CRC bits transmission, otherwise low.      

