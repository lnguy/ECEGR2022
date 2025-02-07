--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	if(WE = '1') then
		if ((to_integer(unsigned(Address)) >= 0) AND (to_integer(unsigned(Address)) <= 127)) then
			i_ram(to_integer(unsigned(Address))) <= DataIn;
		end if;
	end if;
    end if;

	if(OE = '0') then
		if ((to_integer(unsigned(Address)) >= 0) AND (to_integer(unsigned(Address)) <= 127)) then
			DataOut <= i_ram(to_integer(unsigned(Address)));
		else
			DataOut <= (OTHERS => 'Z');
		end if;
	else
		DataOut <= (OTHERS => 'Z');
	end if;

  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;

	signal write_vector_0: std_logic_vector(31 downto 0);
	signal write_vector_1: std_logic_vector(31 downto 0);
	signal write_vector_2: std_logic_vector(31 downto 0);
	signal write_vector_3: std_logic_vector(31 downto 0);
	signal write_vector_4: std_logic_vector(31 downto 0);
	signal write_vector_5: std_logic_vector(31 downto 0);
	signal write_vector_6: std_logic_vector(31 downto 0);
	signal write_vector_7: std_logic_vector(31 downto 0);
	signal write_0: std_logic_vector(31 downto 0);
	signal writein: std_logic_vector(7 downto 0);

begin
    -- Add your code here for the Register Bank implementation
process(WriteCmd, WriteReg)
begin
	if (WriteCmd = '1') then
		case WriteReg is
			 when "01010" => writein <= "00000001";
			 when "01011" => writein <= "00000010";
			 when "01100" => writein <= "00000100";
			 when "01101" => writein <= "00001000";
			 when "01110" => writein <= "00010000";
			 when "01111" => writein <= "00100000";
			 when "10000" => writein <= "01000000";
			 when "10001" => writein <= "10000000";
			 when others => writein <= "00000000";
		end case;
	else
		writein <= "00000000";
	end if;
end process;

ReadData1 <= 	write_vector_0 when (ReadReg1="01010") else
		write_vector_1 when (ReadReg1="01011") else
		write_vector_2 when (ReadReg1="01100") else
		write_vector_3 when (ReadReg1="01101") else
		write_vector_4 when (ReadReg1="01110") else
		write_vector_5 when (ReadReg1="01111") else
		write_vector_6 when (ReadReg1="10000") else
		write_vector_7 when (ReadReg1="10001") else
		write_0 when (ReadReg1="00000") else
		(others => 'Z');

ReadData2 <=	write_vector_0 when (ReadReg2="01010") else
		write_vector_1 when (ReadReg2="01011") else
		write_vector_2 when (ReadReg2="01100") else
		write_vector_3 when (ReadReg2="01101") else
		write_vector_4 when (ReadReg2="01110") else
		write_vector_5 when (ReadReg2="01111") else
		write_vector_6 when (ReadReg2="10000") else
		write_vector_7 when (ReadReg2="10001") else
		write_0 when (ReadReg2="00000") else
		(others => 'Z');

x0: register32 PORT MAP (WriteData,'0','1','1','0','0','0', write_0);
A0_x10: register32 PORT MAP (WriteData,'0','1','1', writein(0),'0','0', write_vector_0);
A1_x11: register32 PORT MAP (WriteData,'0','1','1', writein(1),'0','0', write_vector_1);
A2_x12: register32 PORT MAP (WriteData,'0','1','1', writein(2),'0','0', write_vector_2);
A3_x13: register32 PORT MAP (WriteData,'0','1','1', writein(3),'0','0', write_vector_3);
A4_x14: register32 PORT MAP (WriteData,'0','1','1', writein(4),'0','0', write_vector_4);
A5_x15: register32 PORT MAP (WriteData,'0','1','1', writein(5),'0','0', write_vector_5);
A6_x16: register32 PORT MAP (WriteData,'0','1','1', writein(6),'0','0', write_vector_6);
A7_x17: register32 PORT MAP (WriteData,'0','1','1', writein(7),'0','0', write_vector_7);

end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
