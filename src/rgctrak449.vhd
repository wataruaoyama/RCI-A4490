Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY rgctrak449 IS
PORT(RESET,CLK_40M,XDSD,DIF0,DIF1,DIF2,SMUTE,DEM0,DEM1 : IN std_logic;
		DZFM,DZFE,SD,SLOW,MONO,DSDSEL0,DSDSEL1 : IN std_logic;
		SSLOW,DSDD,SC0,SC1,DDM : IN std_logic;
		A,B : IN std_logic;
		DATA_DSDL,LRCK_DSDR,CLK_SEL,SCK,BCK_DSDCLK : IN std_logic;
		AK4490,AKWM : IN std_logic;
		DISPSW : IN std_logic;
		CSN,CCLK,CDTI : OUT std_logic;
		MCLK,BCLK,DATA,LRCK : OUT std_logic;
		LED_PCM,LED_DSD : OUT std_logic;
		COMSEL : OUT std_logic_vector(3 downto 0);
		LED : OUT std_logic_vector(7 downto 0));
END rgctrak449;

ARCHITECTURE RTL OF rgctrak449 IS

component clkdiv
	PORT(RESET,CLK_40M : IN std_logic;
		CLK : OUT std_logic);
end component;

component regctr
	PORT(RESET,CLK,CLK_MSEC,XDSD,DIF0,DIF1,DIF2,SMUTE,DEM0,DEM1 : IN std_logic;
		DZFM,DZFE,SD,SLOW,MONO,DSDSEL0,DSDSEL1 : IN std_logic;
		SSLOW,DSDD,SC0,SC1 : IN std_logic;
		AK4490 : IN std_logic;
		ATTCOUNT : IN std_logic_vector(7 downto 0);
		CSN,CCLK,CDTI : OUT std_logic);
end component;

component clkgen 
	PORT(RESET,CLK : IN std_logic;
		CLK_MSEC,CLK_FIL,ENDIVCLK : OUT std_logic);
end component;

component attcnt
	port(CLK,RESET_N,A,B : in std_logic;
		CNTUP,CNTDWN : out std_logic;
		Q : out std_logic_vector(7 downto 0));
end component;

component dispctr
	PORT(
	RESET : IN std_logic;
	CLK : IN std_logic;
	CHAT_CLK : IN std_logic;
	ENDIVCLK : IN std_logic;
	ATTDWN : IN std_logic;
	ATTUP : IN std_logic;
	DISPSW : IN std_logic;
	DIN : IN std_logic_vector(7 downto 0);
	COMSEL : OUT std_logic_vector(3 downto 0);
	LED : OUT std_logic_vector(7 downto 0));
end component;

signal clk,clk_msec,chat_clk,endivclk,attup,attdwn : std_logic;
signal attcount : std_logic_vector(7 downto 0);

begin

	R1 : regctr port map (RESET => reset,CLK => clk,CLK_MSEC => clk_msec,XDSD => xdsd,
		DIF0 => dif0,DIF1 => dif1,DIF2 => dif2,SMUTE => smute,DEM0 => dem0,DEM1 => dem1,
		DZFM => dzfm,DZFE => dzfe,SD => sd,SLOW => slow,MONO => mono,
		DSDSEL0 => dsdsel0,DSDSEL1 => dsdsel1,SSLOW => sslow,DSDD => dsdd,SC0 => sc0,SC1 => sc1,
		AK4490 => AK4490,ATTCOUNT => attcount,CSN => csn,CCLK => cclk,CDTI => cdti); 

	C1 : clkgen port map (RESET => reset,CLK => clk,CLK_MSEC => clk_msec,CLK_FIL => chat_clk,ENDIVCLK => endivclk);

	A1 : attcnt port map (CLK => clk,RESET_N => reset,A =>a,B => b,CNTUP => attup,CNTDWN => attdwn,Q => attcount);

	D1 : dispctr port map (RESET => reset,CLK => clk,CHAT_CLK => chat_clk,ENDIVCLK => endivclk,ATTDWN => attdwn,ATTUP => attup,
		DISPSW => DISPSW,DIN => attcount,COMSEL => comsel,LED => LED);
		
	C2 : clkdiv port map (RESET => reset,CLK_40M => clk_40m,CLK => clk);
		
	LRCK <= LRCK_DSDR;
	DATA <= DATA_DSDL;
	BCLK <= BCK_DSDCLK;
	MCLK <= SCK;
	LED_PCM <= not XDSD;
	LED_DSD <= XDSD;
		
end RTL;