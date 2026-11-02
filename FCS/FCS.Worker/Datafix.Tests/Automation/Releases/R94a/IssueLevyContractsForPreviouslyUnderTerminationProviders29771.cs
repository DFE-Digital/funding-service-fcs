namespace Datafix.Tests.Automation.Releases.R94a
{
    using System.Collections.Generic;
    public class IssueLevyContractsForPreviouslyUnderTerminationProviders29771 : IApplyDataFix
    {
        public string Release => "R94a";

        public int StoryNumber => 29771;

        public string Name => "Issue 69 new apprenticeship provider agreements (29771)";

        public int Order => 2;

        public void ApplyDataFix()
        {
            var dasProviderList = new List<int>
            {
                10014157,    //CAPITA BUSINESS SERVICES LTD
                10045988,    //OAKTHORPE PRIMARY SCHOOL 
                10048445,    //TRADE TECHS (NORTHERN) LTD 
                10042662,    //GROOMARTS PB LIMITED 
                10057353,    //TEACH POOLE
                10037669,    //SOUTH QUAY COLLEGE
                10056336,    //PRAGMATIC CONSULTING LTD
                10008912,    //COLEG GWENT
                10081561,    //FIRST CLASS EDUCATION SOLUTIONS LIMITED
                10052835,    //NORTH EAST LEARNING TRUST
                10031111,    //POMPEY IN THE COMMUNITY
                10002756,    //GREAT YARMOUTH COMMUNITY TRUST
                10064877,    //ARRIVA RAIL NORTH LIMITED 
                10063615,    //SCRIVENS LIMITED
                10040403,    //RESURGO TRUST
                10054321,    //TECHNICAL EDUCATION ACADEMY LIMITED
                10062823,    //BLUESTONE COLLEGE LTD
                10065549,    //BRITISH AIRWAYS PLC 
                10001482,    //CLAIRES COURT SCHOOLS
                10030255,    //THE DIASPORA COMMUNITY PROJECTS (DIASPORA)
                10054793,    //MKC TRAINING SERVICES LIMITED 
                10034279,    //DHUNAY CORPORATION LTD
                10030984,    //WEALDEN LEISURE LIMITED
                10009200,    //TEMPUS LEARNING SERVICES LIMITED
                10060111,    //DAY ONE TRUST
                10083474,    //A-SAFE UK LTD
                10043617,    //TECHNIQUE LEARNING SOLUTIONS LTD
                10006186,    //ST. JOHN AMBULANCE
                10062850,    //RAINHILL HIGH SCHOOL
                10061639,    //TRAIN4WORK TRAINING SERVICES LIMITED
                10034267,    //RUNWELL COMMUNITY PRIMARY SCHOOL
                10085130,    //CELLAR TAPES UK LTD
                10081883,    //CORSERV LIMITED
                10083548,    //RIVIERA TUITION LIMITED
                10009922,    //SEWELLS TRAINING AND CONSULTANCY LIMITED
                10002090,    //EAGLE EDUCATION AND TRAINING LIMITED
                10036686,    //R.E.A.L. EDUCATION LIMITED
                10060843,    //WATERTON ACADEMY TRUST 
                10085696,    //FOUNDERS & CODERS C.I.C. 
                10085521,    //UNISERVE HOLDINGS LIMITED 
                10084400,    //AJ BELL BUSINESS SOLUTIONS LIMITED
                10085024,    //RUTHERFORD SEARCH LTD
                10035498,    //COLCHESTER COUNTY HIGH SCHOOL FOR GIRLS
                10041629,    //TIME TRAINING LIMITED
                10028861,    //SAFETY AND ACCESS LIMITED
                10062567,    //CLINICAL PROFESSIONALS LIMITED 
                10067128,    //NERO HOLDINGS LIMITED
                10013118,    //D.T.K. BUSINESS SERVICES LIMITED
                10035578,    //HIBERNIA COLLEGE UK LIMITED
                10007772,    //EDINBURGH NAPIER UNIVERSITY
                10034212,    //BPIF TRAINING LIMITED
                10085899,    //BUSY BEES EDUCATION & TRAINING LIMITED
                10085903,    //DEVELOP CONSULTING LIMITED
                10084622,    //GGS SALON LTD
                10085914,    //JRS TRAINING & ASSESSMENT LTD
                10066160,    //LOTUS EDUCATION LTD
                10012442,    //NISHKAM CIVIC ASSOCIATION
                10085916,    //PARAMOUNT ASSESSMENT LTD
                10066604,    //THE FERNANDES AND ROSARIO CONSULTING LIMITED
                10055525,    //PHOENIX EDUCATION LONDON LIMITED
                10046259,    //PROFESSIONAL TRAINING & DEVELOPMENT SOLUTIONS LTD.
                10052834,    //THE SPENCER ACADEMIES TRUST
                10026271,    //RED SNAPPER LEARNING LTD
                10044334,    //OMNI ACADEMY OF BEAUTY LIMITED
                10065596,    //AUTO-ASSESS LIMITED
                10062402,    //RHEAN UNCENSORED VANITY ACADEMY I LTD.
                10080843,    //GREENLIGHT TRAINING LIMITED
                10034050,    //ULTIMA SKILLS LTD
                10046146,    //ACADEMY TRAINING HAIR AND BEAUTY LIMITED
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}