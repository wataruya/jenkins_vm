library IEEE;
use IEEE.std_logic_1164.all;

entity top_xor is
end top_xor;
 
architecture rtl_code of top_xor is
	signal        clock    :        std_logic := '0';
	signal        xor_in1  :        std_logic;
	signal        xor_in2  :        std_logic;
	signal        xor_out  :        std_logic;
	signal        foo      :        std_logic;
	signal        foo2      :        std_logic;
	signal        foo56789      :        std_logic;
	signal        hello_you : std_logic;
	signal        hello_there : std_logic;
	signal        ciao : std_logic;	
	
	--specman stub
	component comspec
	end component;
	for all: comspec use entity work.SPECMAN_REFERENCE (arch);   
	
	
	-- Verilog module
	component xor_component
	   port(clk     :  in  std_logic;
		xor_in1 :  in  std_logic;
	 	xor_in2 :  in  std_logic;
        	xor_out :  out std_logic
	   );	
	end component;

	for all: xor_component use entity work.xor_module;

begin
   	--specman stub
	spec : comspec;
	
	xor_try : xor_component port map (clock,xor_in1,xor_in2,xor_out);

	clock <= not clock after 20 ns;

end rtl_code;
