///////////////////////////////////////////////////////////////////////////////
//
// 7-SEGMENT LED DRIVER - 6.111 / Lab 1
//
// Created:	January 5, 2006
// Author:	Kyeong-Jae Lee
//
// Decodes a 4-bit input to drive a single 7-segment digit
//
// 7-segment layout:
//		    a
//	 	   ----
//		  |    |
//		f | g  | b
//		   ----
//		  |    |
//		e |    |  c
//		   ----
//		    d
//
///////////////////////////////////////////////////////////////////////////////

module segment_decoder(x, a,b,c,d,e,f,g);
	input [3:0] x;				//4-bit number
	output a,b,c,d,e,f,g;			//driver for each LED segment

	///////////////////////////////////////
	// YOUR CODE GOES HERE
	///////////////////////////////////////


	///////////////////////////////////////
	
endmodule
