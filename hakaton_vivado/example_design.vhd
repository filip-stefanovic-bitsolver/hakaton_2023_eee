----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2023 02:25:26 PM
-- Design Name: 
-- Module Name: example_design - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity example_design is
  port (
    clk               : in  std_logic;
    resetn            : in  std_logic;
    
    axis_slv_tready   : out std_logic;
    axis_slv_tdata    : in  std_logic_vector(7 downto 0);
    axis_slv_tlast    : in  std_logic;
    axis_slv_tvalid   : in  std_logic;
    
    axis_mst0_tvalid  : out std_logic;
    axis_mst0_tdata   : out std_logic_vector(7 downto 0);
    axis_mst0_tlast   : out std_logic;
    axis_mst0_tready  : in  std_logic;
    
    axis_mst1_tvalid  : out std_logic;
    axis_mst1_tdata   : out std_logic_vector(15 downto 0);
    axis_mst1_tlast   : out std_logic;
    axis_mst1_tready  : in  std_logic;
    
    aximm_slv_awaddr  : in  std_logic_vector(31 downto 0);
    aximm_slv_awvalid : in  std_logic;
    aximm_slv_awready : out std_logic;
    
    aximm_slv_wdata   : in  std_logic_vector(31 downto 0);
    aximm_slv_wvalid  : in  std_logic;
    aximm_slv_wready  : out std_logic;
    
    aximm_slv_bresp   : out std_logic_vector(1 downto 0);
    aximm_slv_bvalid  : out std_logic;
    aximm_slv_bready  : in  std_logic;
    
    aximm_slv_araddr  : in  std_logic_vector(31 downto 0);
    aximm_slv_arvalid : in  std_logic;
    aximm_slv_arready : out std_logic;
    
    aximm_slv_rdata   : out std_logic_vector(31 downto 0);
    aximm_slv_rresp   : out std_logic_vector(1 downto 0);
    aximm_slv_rvalid  : out std_logic;
    aximm_slv_rready  : in  std_logic
  );
end example_design;

architecture rtl of example_design is

  signal paddr    : std_logic_vector(11 downto 0);
  signal psel     : std_logic_vector(0 downto 0);
  signal penable  : std_logic;
  signal pwrite   : std_logic;
  signal pwdata   : std_logic_vector(31 downto 0);
  signal pprot    : std_logic_vector(2 downto 0);
  signal pstrb    : std_logic_vector(3 downto 0);
  signal pready   : std_logic_vector(0 downto 0) := (others =>'1');
  signal prdata   : std_logic_vector(31 downto 0);
  signal pslverr  : std_logic_vector(0 downto 0):= (others => '0');
  signal axis_slv_tready_s : std_logic;
  
  -- memory-mapped registers
  signal shift_left_s  : std_logic_vector(31 downto 0) := (others => '0');
  signal shift_right_s : std_logic_vector(31 downto 0) := (others => '0');
  signal rcv_cnt     : integer;
  signal snd_cnt     : integer;
  
  component axi_apb_bridge_0
  PORT (
    s_axi_aclk : IN STD_LOGIC;
    s_axi_aresetn : IN STD_LOGIC;
    s_axi_awaddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;
    s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bready : IN STD_LOGIC;
    s_axi_araddr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;
    s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC;
    m_apb_paddr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    m_apb_psel : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_apb_penable : OUT STD_LOGIC;
    m_apb_pwrite : OUT STD_LOGIC;
    m_apb_pwdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_apb_pready : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_apb_prdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_apb_pslverr : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
  );
  end component;

begin

  axi_apb_bridge_0_inst : axi_apb_bridge_0
  port map (
    s_axi_aclk    => clk,
    s_axi_aresetn => resetn,
    s_axi_awaddr =>  aximm_slv_awaddr(11 downto 0),  
    s_axi_awvalid => aximm_slv_awvalid,
    s_axi_awready => aximm_slv_awready,
    s_axi_wdata => aximm_slv_wdata,
    s_axi_wvalid => (aximm_slv_wvalid),
    s_axi_wready => (aximm_slv_wready),
    s_axi_bresp => (aximm_slv_bresp),
    s_axi_bvalid => (aximm_slv_bvalid),
    s_axi_bready => (aximm_slv_bready),
    s_axi_araddr => aximm_slv_araddr(11 downto 0),
    s_axi_arvalid => (aximm_slv_arvalid),
    s_axi_arready => (aximm_slv_arready),
    s_axi_rdata => (aximm_slv_rdata),
    s_axi_rresp => (aximm_slv_rresp),
    s_axi_rvalid => (aximm_slv_rvalid),
    s_axi_rready => (aximm_slv_rready),
    m_apb_paddr => (paddr),
    m_apb_psel => (psel),
    m_apb_penable => (penable),
    m_apb_pwrite => (pwrite),
    m_apb_pwdata => (pwdata),
    m_apb_pready => (pready),
    m_apb_prdata => (prdata),
    m_apb_pslverr => (pslverr)
  );
    
    
  process(clk, resetn)
  begin
    if resetn = '0' then
      shift_left_s  <= x"00000001";
      shift_right_s <= x"00000001";
      rcv_cnt     <= 0;
      snd_cnt     <= 0;
      pready      <= (others => '1');
      pslverr     <= (others => '0');
      prdata      <= (others => '0');
    elsif rising_edge(clk) then
      pready      <= (others => '1');
      pslverr     <= (others => '0');
      prdata      <= (others => '0');
      if axis_slv_tready_s = '1' and axis_slv_tvalid = '1' then
        rcv_cnt     <= rcv_cnt + 1;
        snd_cnt     <= snd_cnt + 1;
      end if;  
      if psel = std_logic_vector(to_unsigned(1,1)) and penable = '0' then
        case paddr(11 downto 0) is
          when x"000" => 
            if pwrite = '1' then
              shift_left_s <= pwdata;
            else
              prdata <= shift_left_s;
            end if;   
          when x"004" =>
            if pwrite = '1' then
              shift_right_s <= pwdata;
            else
              prdata <= shift_right_s;
            end if;                    
          when x"008" =>
            if pwrite = '1' then
              pslverr <= (others => '1');
            else
              prdata <= std_logic_vector(to_unsigned(rcv_cnt,32));
            end if;    
          when x"00C" =>
            if pwrite = '1' then
              snd_cnt <= 0;
            else
              prdata <= std_logic_vector(to_unsigned(snd_cnt,32));
            end if;
          when others =>
            pslverr <= (others => '1');              
        end case;
      end if;   
    end if;
  end process;
    
  --assign
  axis_slv_tready <= axis_slv_tready_s;
  axis_mst0_tvalid <= axis_mst1_tready and axis_slv_tvalid;
  axis_mst0_tdata  <= std_logic_vector(shift_right(unsigned(axis_slv_tdata),to_integer(unsigned(shift_right_s))));
  axis_mst0_tlast  <= axis_slv_tlast;

  axis_mst1_tvalid <= axis_mst0_tready and axis_slv_tvalid;
  axis_mst1_tdata  <= std_logic_vector(shift_left(unsigned(axis_slv_tdata),to_integer(unsigned(shift_left_s)))) & 
                      std_logic_vector(shift_left(unsigned(axis_slv_tdata),to_integer(unsigned(shift_left_s))));
  axis_mst1_tlast  <= axis_slv_tlast;

  axis_slv_tready  <= axis_mst0_tready and axis_mst1_tready;

end rtl;
