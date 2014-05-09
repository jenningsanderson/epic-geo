def random_hex_color
  (0..5).map{ rand(16).to_s(16) }.join
end

def generate_random_styles(current_file, number_of_styles)
  number_of_styles.times do |id|
    #Generate a random hex color
    color = random_hex_color

    #Open the Style
    current_file.write "<Style id=\"r_style_#{id}\">\n"

    #Point
    current_file.write %Q{\t<IconStyle>
      <color>77#{color}</color>
       <scale>.5</scale>
       <Icon>http://maps.google.com/mapfiles/kml/paddle/wht-blank-lv.png</Icon>
        <LabelStyle>
          <scale>0</scale>
        </LabelStyle>
  </IconStyle>\n}

    #Line
    current_file.write %Q{\t<LineStyle>
      <color>77#{color}</color>
      <width>1.5</width>
  </LineStyle>\n}

    #Poly
    current_file.write %Q{\t<PolyStyle>
      <color>AA#{color}</color>
      <BalloonStyle>
        <text>&lt;h1&gt;$[name]&lt;/h1&gt;$[description]</text>
        <bgColor>ffd5efff</bgColor>
      </BalloonStyle>
  </PolyStyle>\n}
    current_file.write "</Style>\n\n"
  end
end

def write_3_bin_styles
  current_file.write %Q{
  <Style id="before">
    <IconStyle>
      <scale>0.4</scale>
      <Icon>
        <href>http://maps.google.com/mapfiles/kml/paddle/grn-blank-lv.png</href>
      </Icon>
    </IconStyle>
    <LabelStyle>
      <scale>0</scale>
    </LabelStyle>
    <LineStyle>
      <color>ff5bbd00</color>
      <width>1.4</width>
    </LineStyle>
  </Style>

  <Style id="during">
    <IconStyle>
      <scale>0.4</scale>
      <Icon>
        <href>http://maps.google.com/mapfiles/kml/paddle/red-circle-lv.png</href>
      </Icon>
    </IconStyle>
    <LabelStyle>
      <scale>0</scale>
    </LabelStyle>
    <LineStyle>
      <color>ff1515a6</color>
      <width>1.4</width>
    </LineStyle>
  </Style>

  <Style id="after">
    <IconStyle>
      <scale>0.4</scale>
      <Icon>
        <href>http://maps.google.com/mapfiles/kml/paddle/ylw-blank-lv.png</href>
      </Icon>
    </IconStyle>
    <LabelStyle>
      <scale>0</scale>
            </LabelStyle>
    <LineStyle>
      <color>ff7fffff</color>
      <width>1.4</width>
    </LineStyle>
  </Style>}
end
