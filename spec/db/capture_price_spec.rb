require 'spec_helper'

RSpec.describe 'capture price calculations' do
  let(:area) { Area.find_by!(code: 'SA1', region: 'australia', source: 'aemo', type: 'region') }
  let(:pt) { ProductionType.find_by! name: 'wind' }
  let(:apt) { AreasProductionType.find_by(area:, production_type: pt) }
  let(:r) do
    r = Generation.connection.execute <<-SQL
      SELECT
        time_bucket('1h', g.time) AS time,
        AVG(p.value) AS price,

        AVG(g.value) AS kwh,
        AVG(GREATEST(0,g.value)) AS kwh_generated,
        AVG(LEAST(0,g.value)) AS kwh_consumed,

	AVG(g.value) AS kwh,
        AVG(GREATEST(0,g.value)) AS kwh_generated,
        AVG(LEAST(0,g.value)) AS kwh_consumed,

	AVG(p.value::bigint*g.value) AS revenue,
        AVG(p.value::bigint*GREATEST(0,g.value)) AS revenue_generated,
        AVG(p.value::bigint*LEAST(0,g.value)) AS revenue_consumed
      FROM generation g
      INNER JOIN prices p ON(g.time=p.time)
      WHERE g.area_id=#{area.id} AND g.time BETWEEN '#{time}' AND '#{time + period*period_steps}'
      GROUP BY 1
    SQL
    r.to_a
  end
  let(:first) { r.first }
  let(:time) { Time.new(2023,1,1) }
  let(:period) { 5.minutes }
  let(:period_steps) { 12 }

  before do
    area.generation.insert_all(
      period_steps.times.map do |i|
        {value: kwh.is_a?(Array) ? kwh[i] : kwh, time: time + i*period, production_type_id: pt.id, areas_production_type_id: apt.id}
      end
    )
    area.prices.insert_all(
      period_steps.times.map do |i|
        {value: price.is_a?(Array) ? price[i] : price, time: time + i*period}
      end
    )
  end

  context 'with positive output and price' do
    let(:kwh) { 1000 }
    let(:price) { 10 }
    it { expect(first['kwh']).to eq 1000 }
    it { expect(first['revenue']).to eq 10000 }
    xit { expect(first['capture_price']).to eq 10 }
  end
  context 'with negative output and price' do
    let(:kwh) { -1000 }
    let(:price) { -10 }
    it { expect(first['revenue']).to eq 10000 }
  end
  context 'with positive output and negative price' do
    let(:kwh) { 1000 }
    let(:price) { -10 }
    it { expect(first['revenue']).to eq -10000 }
  end
  context 'with negative output and positive price' do
    let(:kwh) { -1000 }
    let(:price) { 10 }
    it { expect(first['revenue']).to eq -10000 }
  end
  context "mixed values" do
    let(:kwh) { [1000,1000,1000,1000,1000,1000,-1000,-1000,-1000,-1000,-1000,-1000] }
    let(:price) { 10 }
    it { expect(first['revenue']).to eq 0 }
    #it { require 'pry' ; binding.pry }
    it { expect(first['kwh']).to eq 0 }
    it { expect(first['kwh_generated']).to eq 500 }
    it { expect(first['kwh_consumed']).to eq -500 }
    xit { expect(first['capture_price']).to eq 0 }
  end
  context 'extreme result' do
    let(:kwh) { [2000,-1000] }
    let(:price) { 10 }
    let(:period_steps) { 2 }
    let(:period) { 30.minutes }
    it { expect(first['revenue']).to eq 5000 }
    xit { expect(r.first['capture_price']).to eq 0 }
  end
end
