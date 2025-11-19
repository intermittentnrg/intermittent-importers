module Opennem
  class Base
    def self.source_id
      "opennem"
    end
    REGION_MAP = {
      "AUS-NSW" => "NSW1",
      "AUS-QLD" => "QLD1",
      "AUS-SA" => "SA1",
      "AUS-TAS" => "TAS1",
      "AUS-VIC" => "VIC1",
      "AUS-WA" => "WEM",
    }
    NETWORK_MAP = {
      "AUS-NSW" => "NEM",
      "AUS-QLD" => "NEM",
      "AUS-SA" => "NEM",
      "AUS-TAS" => "NEM",
      "AUS-VIC" => "NEM",
      "AUS-WA" => "WEM",
    }
    FUEL_MAP = {
      "coal_black" => "fossil_hard_coal",
      "coal_brown" => "fossil_brown_coal/lignite",
      "gas_ccgt" => "fossil_gas_ccgt",
      "gas_ocgt" => "fossil_gas_ocgt",
      "gas_recip" => "fossil_gas_reciprocating",
      "gas_steam" => "fossil_gas_steam",
      "gas_wcmg" => "fossil_gas_coal_mine_waste",
      "distillate" => "fossil_oil_distillate",
      "hydro" => "hydro",
      "wind" => "wind",
      "bioenergy_biogas" => "biogas",
      "bioenergy_biomass" => "biomass",
      "solar_utility" => "solar_utility",
      "solar_rooftop" => "solar_rooftop",
      # Storage
      "battery_charging" => "battery_charging",
      "battery_discharging" => "battery",
      "pumps" => "hydro_pumped_storage",
    }
  end
end
