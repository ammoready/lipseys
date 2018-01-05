module Mocker

  def default_headers
    {
      'Accept' => '*/*',
      'Host' => 'www.lipseys.com'
    }
  end

  def sample_catalog_response
    <<~XML
      <LipseysCatalog>
        <Item>
          <ItemNo>BEJ212500</ItemNo>
          <Desc1>21 BOBCAT INOX 22LR SS/BLK 7+1</Desc1>
          <Desc2>2.4 TIP-UP BBL | PLASTIC CASE</Desc2>
          <UPC>082442188744</UPC>
          <MFGModelNo>J212500</MFGModelNo>
          <MSRP>410.00</MSRP>
          <Model>21 Bobcat</Model>
          <Caliber>22 LR</Caliber>
          <MFG>Beretta</MFG>
          <Type>Semi-Auto Pistol</Type>
          <Action>Double / Single Action</Action>
          <Barrel>2.4"</Barrel>
          <Capacity>7+1</Capacity>
          <Finish>Stainless</Finish>
          <Length>4.9"</Length>
          <Receiver/>
          <Safety>2 Position Frame Mounted</Safety>
          <Sights>Fixed</Sights>
          <StockFrameGrips>Alloy Frame / Black Plastic Grips</StockFrameGrips>
          <Magazine>1 / 7 rd.</Magazine>
          <Weight>11.8 oz.</Weight>
          <Image>bebobcatss.jpg</Image>
        </Item>
        <Item>
          <ItemNo>BEJ320500</ItemNo>
          <Desc1>3032 TOMCAT INOX 32ACP SS/SY</Desc1>
          <Desc2>2.4 BBL | 7+1 | PLASTIC CASE</Desc2>
          <UPC>082442188812</UPC>
          <MFGModelNo>J320500</MFGModelNo>
          <MSRP>485.00</MSRP>
          <Model>3032 Tomcat</Model>
          <Caliber>32 ACP</Caliber>
          <MFG>Beretta</MFG>
          <Type>Semi-Auto Pistol</Type>
          <Action>Double / Single Action</Action>
          <Barrel>2.4"</Barrel>
          <Capacity>7+1</Capacity>
          <Finish>Stainless</Finish>
          <Length>4.9"</Length>
          <Receiver/>
          <Safety>2 Position Frame Mounted</Safety>
          <Sights>Fixed</Sights>
          <StockFrameGrips>Alloy Frame / Black Plastic Grips</StockFrameGrips>
          <Magazine>2 / 7 rd.</Magazine>
          <Weight>11.8 oz.</Weight>
          <Image>betomcatss.jpg</Image>
        </Item>
      </LipseysCatalog>
    XML
  end

  def sample_inventory_response
    <<~XML
      <LipseysInventoryPricing>
        <Item>
          <ItemNo>BEJ212500</ItemNo>
          <UPC>082442188744</UPC>
          <MFGModelNo>J212500</MFGModelNo>
          <QtyOnHand>0</QtyOnHand>
          <Alloc>Y</Alloc>
          <Price>305.00</Price>
          <OnSale/>
          <RetailMAP>378.00</RetailMAP>
        </Item>
        <Item>
          <ItemNo>BEJ320500</ItemNo>
          <UPC>082442188812</UPC>
          <MFGModelNo>J320500</MFGModelNo>
          <QtyOnHand>0</QtyOnHand>
          <Alloc>Y</Alloc>
          <Price>360.00</Price>
          <OnSale/>
          <RetailMAP>448.00</RetailMAP>
        </Item>
      </LipseysInventoryPricing>
    XML
  end

end
