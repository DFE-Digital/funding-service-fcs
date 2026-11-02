namespace Datafix.Tests.Automation.Releases.R75b
{
    using System.Collections.Generic;

    public class DasEventsFixDec11th2019 : IApplyDataFix
    {
        public string Release => "R75B";

        public int StoryNumber => 28580;

        public string Name => "Insert Das Events as is they came from the Feed - December 11th 2019";

        public int Order => 1;

        public void ApplyDataFix()
        {
            List<int> dasProviderList = new List<int>
            {
                10037198, // A S TRAINING (INTERNATIONAL) LIMITED
                10024973, // ALPHA DEVELOPMENT PARTNERSHIP LTD
                10061152, // ANGELA SMITH
                10057125, // CONSTRUCTION DEVELOPMENT CENTRE LTD
                10049694, // GREYFRIARS MINISTRIES LTD
                10082134, // HOMESERVE MEMBERSHIP LIMITED
                10064146, // LIVE BETTER LOCATIONS LIMITED
                10056040, // LONDON SCHOOL OF EDUCATION AND MANAGEMENT LIMITED
                10004232, // MASTER CUTTERS LIMITED
                10063562, // NORTH EAST AUTISM SOCIETY
                10083445, // SERCO HOLDINGS LIMITED
                10068400, // SOFTOOLS LIMITED
                10032648, // SPORT STRUCTURES EDUCATION COMMUNITY INTEREST COMPANY
                10083564, // SWIFTOOL PRECISION ENGINEERING LIMITED
                10058030, // THE CODERS GUILD LTD
                10034037, // THE EQUESTRIAN LEARNING ACADEMY LIMITED
                10082027, // THE OCM GROUP LIMITED
                10007787, // THE UNIVERSITY OF BUCKINGHAM
                10048445, // TRADE TECHS (NORTHERN) LTD
                10046866, // VITA SKILLS LIMITED
                10029768  // INFINITE LEARNING AND DEVELOPMENT LTD
            };

            PostDasEvents.AddAndProcessDasEvents(dasProviderList);
        }
    }
}
