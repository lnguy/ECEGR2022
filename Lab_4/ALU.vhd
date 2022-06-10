--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity fulladder is
    port (a : in std_logic;
          b : in std_logic;
          cin : in std_logic;
          sum : out std_logic;
          carry : out std_logic
         );
end fulladder;

architecture addlike of fulladder is
begin
  sum   <= a xor b xor cin; 
  carry <= (a and b) or (a and cin) or (b and cin); 
end architecture addlike;


--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	bit_1: bitstorage PORT MAP (datain(0), enout, writein, dataout(0));
	bit_2: bitstorage PORT MAP (datain(1), enout, writein, dataout(1));
	bit_3: bitstorage PORT MAP (datain(2), enout, writein, dataout(2));
	bit_4: bitstorage PORT MAP (datain(3), enout, writein, dataout(3));
	bit_5: bitstorage PORT MAP (datain(4), enout, writein, dataout(4));
	bit_6: bitstorage PORT MAP (datain(5), enout, writein, dataout(5));
	bit_7: bitstorage PORT MAP (datain(6), enout, writein, dataout(6));
	bit_8: bitstorage PORT MAP (datain(7), enout, writein, dataout(7));
end architecture memmy;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	-- hint: you'll want to put register8 as a component here 
	-- so you can use it below
	component register8
		port(datain: in std_logic_vector(7 downto 0);
			enout:  in std_logic;
	     		writein: in std_logic;
	     		dataout: out std_logic_vector(7 downto 0));
	end component;
	
	signal enableout: std_logic_vector(2 downto 0);
	signal writin: std_logic_vector(2 downto 0);
	signal enablingout: std_logic_vector(3 downto 0);
	signal writingin: std_logic_vector(3 downto 0);
	
begin

	enableout <= enout32 & enout16 & enout8;
	writin <= writein32 & writein16 & writein8;

	with enableout select
		enablingout <= "1110" when "110",
				"1100" when "101",
				"0000" when "011",
				"1111" when others;
	with writin select
		writingin <= "0001" when "001",
				"0011" when "010",
				"1111" when "100",
				"0000" when others;

	reg1: register8 PORT MAP (datain(31 downto 24), enablingout(3), writingin(3), dataout(31 downto 24));
	reg2: register8 PORT MAP (datain(23 downto 16), enablingout(2), writingin(2), dataout(23 downto 16));
	reg3: register8 PORT MAP (datain(15 downto 8), enablingout(1), writingin(1), dataout(15 downto 8));
	reg4: register8 PORT MAP (datain(7 downto 0), enablingout(0), writingin(0), dataout(7 downto 0));
end architecture biggermem;

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity adder_subtracter is
	port(	datain_a: in std_logic_vector(31 downto 0);
		datain_b: in std_logic_vector(31 downto 0);
		add_sub: in std_logic;
		dataout: out std_logic_vector(31 downto 0);
		co: out std_logic);
end entity adder_subtracter;

architecture calc of adder_subtracter is
	component fulladder
		port (a : in std_logic;
        	  b : in std_logic;
        	  cin : in std_logic;
        	  sum : out std_logic;
        	  carry : out std_logic
	         );
	end component;
	
	signal tempB: std_logic_vector(31 downto 0);
	signal C: std_logic_vector(32 downto 0);

begin
	C(0) <= add_sub;
	co <= C(32);

	with add_sub select
		tempB <= datain_b when '0',
			not datain_b when others;

	adder0: fulladder PORT MAP (datain_a(0), tempB(0), C(0), dataout(0), C(1));
	genAdders: for i in 31 downto 1 generate
			adderi: fulladder PORT MAP (datain_a(i), tempB(i), C(i), dataout(i), C(i+1));
	end generate;

end architecture calc;


--------------------------------------------------------------------------------


Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity shift_register is
	port(	datain: in std_logic_vector(31 downto 0);
	   	dir: in std_logic;
		shamt:	in std_logic_vector(4 downto 0);
		dataout: out std_logic_vector(31 downto 0));
end entity shift_register;

architecture shifter of shift_register is
	
begin
	with dir & shamt (1 downto 0) select
		dataout <= datain(30 downto 0) & '0' when "001",
			'0' & datain(31 downto 1) when "101",
			datain(29 downto 0) & "00" when "010",
			"00" & datain(31 downto 2) when "110",
			datain(28 downto 0) & "000" when "011",
			"000" & datain(31 downto 3) when "111",
			datain when others;
end architecture shifter;

--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	signal add_sub_output: std_logic_vector(31 downto 0);
	signal shift_output: std_logic_vector(31 downto 0);
	signal and_output: std_logic_vector(31 downto 0);
	signal or_output: std_logic_vector(31 downto 0);
	signal output: std_logic_vector(31 downto 0);
	signal carry_out: std_logic;

begin
	AddSub_op: adder_subtracter PORT MAP (DataIn1, DataIn2, ALUCtrl(2), add_sub_output, carry_out);
	Shift_op: shift_register PORT MAP (DataIn1, ALUCtrl(3), DataIn2(4 downto 0), shift_output);
	and_output <= DataIn1(31 downto 0) AND DataIn2(31 downto 0);
	or_output <= DataIn1(31 downto 0) AND DataIn2(31 downto 0);
	
	output <= add_sub_output when ALUCtrl(3 downto 0) = "0010" OR ALUCtrl(3 downto 0) = "0110" ELSE
		  shift_output when ALUCtrl(3 downto 0) = "0100" OR ALUCtrl(3 downto 0) = "1100" ELSE
		  and_output when ALUCtrl(3 downto 0) = "0000" ELSE
		  or_output when ALUCtrl(3 downto 0) = "0001" ELSE
		  DataIn2 when ALUCtrl = "11111";

	ALUResult <= output;

	with output select
		Zero <= '1' when x"00000000",
		'0' when others; 
	

end architecture ALU_Arch;


