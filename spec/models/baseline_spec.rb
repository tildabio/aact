require 'rails_helper'

describe Baseline do
  it "study should have expected baseline" do
    nct_id='NCT02028676'
    xml=Nokogiri::XML(File.read("spec/support/xml_data/#{nct_id}.xml"))
    study=Study.new({xml: xml, nct_id: nct_id}).create

    expect(Baseline.count).to eq(1)
    expect(study.baseline.population).to eq('All participants who were randomized were included except those who were randomised in error (main enrollment: 1 child HIV-uninfected, 2 on main phase of tuberculosis treatment; cotrimoxazole secondary randomization: 2 children receiving dapsone prophylaxis not cotrimoxazole).')
    expect(study.baseline.measures.size).to eq(380);
    bm=study.baseline.measures.select{|x|x.title=='Gender'  && x.classification=='Female' && x.ctgov_group_code=='B1'}.first
    expect(bm.param_type).to eq('Number');
    expect(bm.category).to eq('');
    expect(bm.units).to eq('participants');
    expect(bm.param_value).to eq('308');
    bm3=study.baseline.measures.select{|x|x.title=='Gender'  && x.classification=='Female' && x.ctgov_group_code=='B3'}.first
    expect(bm3.param_type).to eq('Number');
    expect(bm3.param_value).to eq('NA');
    expect(bm3.explanation_of_na).to eq('Different randomized comparison');
    expect(bm3.dispersion_upper_limit).to eq(nil);

    expect(study.baseline.analyses.size).to eq(10);
    ba1=study.baseline.analyses.select{|x|x.units=='Participants' && x.scope=='Overall' && x.ctgov_group_code=='B1'}.first
    ba3=study.baseline.analyses.select{|x|x.units=='Participants' && x.scope=='Overall' && x.ctgov_group_code=='B3'}.first
    expect(ba1.count).to eq(606);
    expect(ba3.count).to eq(397);

    expect(study.baseline.groups.size).to eq(10);
    bg1=study.baseline.groups.select{|x| x.ctgov_group_code=='B1'}.first
    bg10=study.baseline.groups.select{|x| x.ctgov_group_code=='B10'}.first

    expect(bg1.title).to eq('Clinically Driven Monitoring (CDM)');
    expect(bg10.title).to eq('Total')

    expect(bg1.description).to eq('Clinically Driven Monitoring (CDM): Participants were examined by a doctor and had routine full blood count with white cell differential, lymphocyte subsets (CD4, CD8), biochemistry tests (bilirubin, urea, creatinine, aspartate aminotransferase, alanine aminotransferase) at screening, randomisation (lymphocytes only), weeks 4, 8, and 12, then every 12 weeks. Screening results were used to assess eligibility. All subsequent results were only returned if requested for clinical management (authorised by centre project leaders); haemoglobin results at week 8 were automatically returned on the basis of early anaemia in a previous adult trial as were grade 4 laboratory toxicities (protocol safety criteria). Total lymphocytes and CD4 tests were never returned for CDM participants, but for all children other investigations (including tests from the routine panels) could be requested and concomitant drugs prescribed, as clinically indicated at extra patient-initiated or scheduled visits.')
    expect(bg10.description).to eq('Total of all reporting groups')
  end

end
