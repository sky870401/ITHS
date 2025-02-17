
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module DE10_LITE_RFS_SENSOR_RTL(

	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// GPIO, GPIO connect to RFS - RF and Sensor //////////
	inout 		          		BT_KEY,
	input 		          		BT_UART_RX,
	output		          		BT_UART_TX,
	input 		          		LSENSOR_INT,
	inout 		          		LSENSOR_SCL,
	inout 		          		LSENSOR_SDA,
	output		          		MPU_AD0_SDO,
	output		          		MPU_CS_n,
	output		          		MPU_FSYNC,
	input 		          		MPU_INT,
	inout 		          		MPU_SCL_SCLK,
	inout 		          		MPU_SDA_SDI,
	input 		          		RH_TEMP_DRDY_n,
	inout 		          		RH_TEMP_I2C_SCL,
	inout 		          		RH_TEMP_I2C_SDA,
	inout 		     [7:0]		TMD_D,
	input 		          		UART2USB_CTS,
	output		          		UART2USB_RTS,
	input 		          		UART2USB_RX,
	output		          		UART2USB_TX,
	output		          		WIFI_EN,
	output		          		WIFI_RST_n,
	input 		          		WIFI_UART0_CTS,
	output		          		WIFI_UART0_RTS,
	input 		          		WIFI_UART0_RX,
	output		          		WIFI_UART0_TX,
	input 		          		WIFI_UART1_RX
);



//=======================================================
//  REG/WIRE declarations
//======================================================
   wire       RESET_N ; 
   wire [7:0] BCD_T , BCD_H;  
   wire [7:0] POWERUP	 ; 
   
   wire [15:0] DATA0  ; 
   wire [15:0] DATA1  ; 
   wire        HM_TR ;
	wire [15:0] HM_XOUT;
	wire [15:0] HM_YOUT;
	wire [15:0] HM_ZOUT;	
 	wire [15:0] ACCEL_XOUT;
	wire [15:0] ACCEL_YOUT;
	wire [15:0] ACCEL_ZOUT;
	wire [15:0] TEMP_OUT;
	wire [15:0] GYRO_XOUT;
	wire [15:0] GYRO_YOUT;
	wire [15:0] GYRO_ZOUT;
	wire [7:0 ] INT_STATUS;  
//=======================================================
//  Structural coding
//=======================================================


//---- RESET ---
assign RESET_N =KEY[0];
//----Humidity -Temperature SENSOR ---	
HC1000 HC(
      .RESET_N        (RESET_N        ),
      .CLOCK_50       (MAX10_CLK1_50       ),
      .RH_TEMP_DRDY_n (RH_TEMP_DRDY_n ),
      .RH_TEMP_I2C_SCL(RH_TEMP_I2C_SCL), 
      .RH_TEMP_I2C_SDA(RH_TEMP_I2C_SDA),
      .BCD_T          (BCD_T), 
      .BCD_H          (BCD_H)
);		
	
//----LIGHT SENSOR ---	
APDS_9301 ctl( 
   //--SYSTEM--   
	.RESET_N  (RESET_N),
   .CLK_50   (MAX10_CLK1_50),
	//--IC SIDE-- 
	.RDY_n    (LSENSOR_INT),   
	.I2C_SCL  (LSENSOR_SCL),
	.I2C_SDA  ( LSENSOR_SDA), 
	.DATA0    (DATA0 ),
	.DATA1    (DATA1 ),
   .POWERUP  (POWERUP) 
	);


//---- RESET ---
	
assign MPU_AD0_SDO =0;
assign MPU_CS_n    =1; 
assign MPU_FSYNC   =0; 
//----Humidity_Temperature ---	
MPU_9250  ctlPP( 
   //--SYSTEM-- 
	.RESET_N 	 ( RESET_N ),
   .CLK_50      ( MAX10_CLK1_50 ),
	.SW           (SW [7:0]) , 
	//--IC SIDE--
	.RDY_n       ( MPU_INT),   
	.I2C_SCL     ( MPU_SCL_SCLK),
	.I2C_SDA     ( MPU_SDA_SDI ),
	.ACCEL_XOUT  (ACCEL_XOUT),
	.ACCEL_YOUT  (ACCEL_YOUT),
	.ACCEL_ZOUT  (ACCEL_ZOUT),
	.TEMP_OUT    (TEMP_OUT  ),
	.GYRO_XOUT   (GYRO_XOUT ),
	.GYRO_YOUT   (GYRO_YOUT ),
	.GYRO_ZOUT   (GYRO_ZOUT ),
	.INT_STATUS  (INT_STATUS ),
	.HM_XOUT     (HM_XOUT),
	.HM_YOUT     (HM_YOUT),
	.HM_ZOUT     (HM_ZOUT),
	.TR(HM_TR) ,	
	
	);


//----------------4 HEX VIEW -------
//sw:0  HUMITY-TEMP       
//sw:1  LIGHT SENSOR ADC0 (DATA0)
//sw:2  LIGHT SENSOR ADC1 (DATA1)
//sw:3  THREE-AXIS MEMS ACCELEROMETER X
//sw:4  THREE-AXIS MEMS ACCELEROMETER Y
//sw:5  THREE-AXIS MEMS ACCELEROMETER Z
//sw:6  THREE-AXIS MEMS GYROSCOPE     X
//sw:7  THREE-AXIS MEMS GYROSCOPE     Y
//sw:8  THREE-AXIS MEMS GYROSCOPE     Z
//sw:9  THREE-AXIS MEMS MAGNETOMETER  X
//sw:10 THREE-AXIS MEMS MAGNETOMETER  Y
//sw:11 THREE-AXIS MEMS MAGNETOMETER  Z
//---------------------------------
//-----HEX SWITCHER ---- 
HEX_SWITCH  swh(
   .SW        ( SW   ), 
	.BCD_T     ( BCD_T),
   .BCD_H     ( BCD_H),
	.DATA0     ( DATA0),
	.DATA1     ( DATA1),
 	.ACCEL_XOUT( ACCEL_XOUT),
	.ACCEL_YOUT( ACCEL_YOUT),
	.ACCEL_ZOUT( ACCEL_ZOUT),
	.GYRO_XOUT ( GYRO_XOUT ),
	.GYRO_YOUT ( GYRO_YOUT ),
	.GYRO_ZOUT ( GYRO_ZOUT ),
	.HM_XOUT   ( HM_XOUT   ),
	.HM_YOUT   ( HM_YOUT   ),
	.HM_ZOUT   ( HM_ZOUT   ),	
	.RH_TEMP_DRDY_n(RH_TEMP_DRDY_n),
	.POWERUP   ( POWERUP ), 
	.HM_TR     ( HM_TR   ), 
 	.HEX0      ( HEX0    ),
	.HEX1      ( HEX1    ),
	.HEX2      ( HEX2    ),
	.HEX3      ( HEX3    ),
	.HEX4      ( HEX4    ),
	.HEX5      ( HEX5    ),
	.HEX6      ( HEX6    ),
	.HEX7      ( HEX7    ),
	.LEDR      ( LEDR    )
); 


endmodule
