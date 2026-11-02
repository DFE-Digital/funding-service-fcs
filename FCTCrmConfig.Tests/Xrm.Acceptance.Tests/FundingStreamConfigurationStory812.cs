using Microsoft.VisualStudio.TestTools.UnitTesting;
using SFA.FCT.Xrm.TestFramework;
using System;

namespace SFA.FCT.Xrm.Acceptance.Tests
{
    [TestClass]
    public class FundingStreamConfigurationStory812
    {

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "812")]
        public void ConfirmPeriodTypeCode()
        {
            var PeriodTypes = TestBase.CrmConfiguration.Entity("Period Type");

            TestBase.Connection.GetRecord(PeriodTypes, "AY")
                .FieldValueEquals("Period Type Name", "Academic Year");

            TestBase.Connection.GetRecord(PeriodTypes, "FY")
                .FieldValueEquals("Period Type Name", "Financial Year");

            TestBase.Connection.GetRecord(PeriodTypes, "CY")
                .FieldValueEquals("Period Type Name", "Calender Year");

            TestBase.Connection.GetRecord(PeriodTypes, "ESF")
                .FieldValueEquals("Period Type Name", "European Social Fund");

            TestBase.Connection.GetRecord(PeriodTypes, "EOP")
                .FieldValueEquals("Period Type Name", "Employer Ownership Pilot");

            TestBase.Connection.GetRecord(PeriodTypes, "EOF")
                .FieldValueEquals("Period Type Name", "Employer Ownership Fund");

            TestBase.Connection.GetRecord(PeriodTypes, "EOP2")
                .FieldValueEquals("Period Type Name", "Employer Ownership Pilot Round 2");

            TestBase.Connection.GetRecord(PeriodTypes, "EOP2P2")
                .FieldValueEquals("Period Type Name", "Employer Ownership Pilot Round 2 Phase 2");

        }


        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "812")]
        public void ConfirmPeriodTable()
        {
            var period = TestBase.CrmConfiguration.Entity("Funding Period");
            //var PeriodType = TestBase.CrmConfiguration.Entity("Period Type");

            TestBase.Connection.GetRecord(period, "AY1516")
                //.LookupFieldValueEquals(PeriodType, "Period Type", "AY")
                .FieldValueEquals("Period", "1516")
                .FieldValueEquals("Start Date", new DateTime(2015, 8, 1))
                .FieldValueEquals("End Date", new DateTime(2016, 7, 31));

            TestBase.Connection.GetRecord(period, "FY1516")
                //.FieldValueEquals("Period Type", "FY")
                .FieldValueEquals("Period", "1516")
                .FieldValueEquals("Start Date", new DateTime(2015, 4, 01))
                .FieldValueEquals("End Date", new DateTime(2016, 3, 31));

            TestBase.Connection.GetRecord(period, "CY2015")
                //.FieldValueEquals("Period Type", "CY")
                .FieldValueEquals("Period", "2015")
                .FieldValueEquals("Start Date", new DateTime(2015, 1, 01))
                .FieldValueEquals("End Date", new DateTime(2015, 12, 31));

            TestBase.Connection.GetRecord(period, "ESF1420")
                //.FieldValueEquals("Period Type", "ESF")
                .FieldValueEquals("Period", "1420")
                .FieldValueEquals("Start Date", new DateTime(2014, 8, 01))
                .FieldValueEquals("End Date", new DateTime(2022, 12, 31));

            TestBase.Connection.GetRecord(period, "EOP1516")
                //.FieldValueEquals("Period Type", "EOP")
                .FieldValueEquals("Period", "1516")
                .FieldValueEquals("Start Date", new DateTime(2015, 8, 01))
                .FieldValueEquals("End Date", new DateTime(2016, 7, 31));

            TestBase.Connection.GetRecord(period, "EOF1417")
                //.FieldValueEquals("Period Type", "EOF")
                .FieldValueEquals("Period", "1417")
                .FieldValueEquals("Start Date", new DateTime(2014, 4, 01))
                .FieldValueEquals("End Date", new DateTime(2020, 3, 31));

            TestBase.Connection.GetRecord(period, "EOP21317")
                //.FieldValueEquals("Period Type", "EOP2")
                .FieldValueEquals("Period", "1317")
                .FieldValueEquals("Start Date", new DateTime(2013, 10, 01))
                .FieldValueEquals("End Date", new DateTime(2020, 3, 31));

            TestBase.Connection.GetRecord(period, "EOP2P21317")
                //.FieldValueEquals("Period Type", "EOP2P2")
                .FieldValueEquals("Period", "1317")
                .FieldValueEquals("Start Date", new DateTime(2013, 10, 01))
                .FieldValueEquals("End Date", new DateTime(2020, 3, 31));
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "812")]
        public void ConfirmFundingStreams()
        {
            var fundingStreamPeriod = TestBase.CrmConfiguration.Entity("Funding Stream Period");
            var FundingStream = TestBase.CrmConfiguration.Entity("Funding Stream");

            TestBase.Connection.GetRecord(FundingStream, "16-18 APPS")
                .FieldValueEquals("Funding Stream Name", "16-18 Apprenticeships")
                .FieldValueEquals("Funding Stream Short Code", "16AP");
             
            TestBase.Connection.GetRecord(FundingStream, "ASC")
                .FieldValueEquals("Funding Stream Name", "Adults Skills (College)")
                .FieldValueEquals("Funding Stream Short Code", "ASC");

            TestBase.Connection.GetRecord(FundingStream, "ASTO")
                .FieldValueEquals("Funding Stream Name", "Adults Skills (Training Organisations)")
                .FieldValueEquals("Funding Stream Short Code", "ASTO");

            TestBase.Connection.GetRecord(FundingStream, "CL")
                .FieldValueEquals("Funding Stream Name", "Community Learning")
                .FieldValueEquals("Funding Stream Short Code", "CL");

            TestBase.Connection.GetRecord(FundingStream, "DLS")
                .FieldValueEquals("Funding Stream Name", "Discretionary Learner Support")
                .FieldValueEquals("Funding Stream Short Code", "DLS");

            TestBase.Connection.GetRecord(FundingStream, "ESF 201420")
                .FieldValueEquals("Funding Stream Name", "European Social Fund 2014-20")
                .FieldValueEquals("Funding Stream Short Code", "ESF");

            TestBase.Connection.GetRecord(FundingStream, "AGE")
                .FieldValueEquals("Funding Stream Name", "Apprenticeship Grant for Employers")
                .FieldValueEquals("Funding Stream Short Code", "AGE");

            TestBase.Connection.GetRecord(FundingStream, "24+ ALLF")
                .FieldValueEquals("Funding Stream Name", "24+ Advanced Learning Loans Facility")
                .FieldValueEquals("Funding Stream Short Code", "ALLF");

            TestBase.Connection.GetRecord(FundingStream, "24+ ALLBC")
                .FieldValueEquals("Funding Stream Name", "24+ Advanced Learning Loans Bursary (College)")
                .FieldValueEquals("Funding Stream Short Code", "ALLBC");

            TestBase.Connection.GetRecord(FundingStream, "24+ ALLB")
                .FieldValueEquals("Funding Stream Name", "24+ Advanced Learning Loans Bursary")
                .FieldValueEquals("Funding Stream Short Code", "ALLB");

            TestBase.Connection.GetRecord(FundingStream, "EOP")
                .FieldValueEquals("Funding Stream Name", "Employer Ownership Pilot")
                .FieldValueEquals("Funding Stream Short Code", "EOP");

            TestBase.Connection.GetRecord(FundingStream, "EOP2")
                .FieldValueEquals("Funding Stream Name", "Employer Ownership Pilot 2")
                .FieldValueEquals("Funding Stream Short Code", "EOP2");

            TestBase.Connection.GetRecord(FundingStream, "EOP2P2")
                .FieldValueEquals("Funding Stream Name", "Employer Ownership Pilot 2 Phase 2")
                .FieldValueEquals("Funding Stream Short Code", "2EOP2");

            TestBase.Connection.GetRecord(FundingStream, "OLASS")
                .FieldValueEquals("Funding Stream Name", "Adult OLASS")
                .FieldValueEquals("Funding Stream Short Code", "OLAS");

            TestBase.Connection.GetRecord(FundingStream, "EOF")
                .FieldValueEquals("Funding Stream Name", "Employer Ownership Fund")
                .FieldValueEquals("Funding Stream Short Code", "EOF");
        }

        [TestMethod]
        [TestCategory("CRMAcceptanceTests")]
        [TestProperty("StoryNo", "812")]
        public void ConfirmFundingStreamPeriod()
        {
            var fundingStreamPeriod = TestBase.CrmConfiguration.Entity("Funding Stream Period");
            var fundingStream = TestBase.CrmConfiguration.Entity("Funding Stream");
            var period = TestBase.CrmConfiguration.Entity("Funding Period");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "16-18APPS1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "16-18 APPS");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "ASC1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "ASC");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "ASTO1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "ASTO");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "CL1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "CL");
               
            TestBase.Connection.GetRecord(fundingStreamPeriod, "DLS1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "DLS");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "ESF1420")
                .LookupFieldValueEquals(period, "Period", "ESF1420")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "ESF 201420");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "AGE1516")
                .LookupFieldValueEquals(period, "Period", "FY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "AGE");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "24+ALLF1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "24+ ALLF");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "24+ALLBC1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "24+ ALLBC");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "24+ALLB1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "24+ ALLB");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "EOP1516")
                .LookupFieldValueEquals(period, "Period", "EOP1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "EOP");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "EOP21317")
                .LookupFieldValueEquals(period, "Period", "EOP21317")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "EOP2");
             
            TestBase.Connection.GetRecord(fundingStreamPeriod, "EOP2P2-1317")
                .LookupFieldValueEquals(period, "Period", "EOP2P21317")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "EOP2P2");

            TestBase.Connection.GetRecord(fundingStreamPeriod, "OLASS1516")
                .LookupFieldValueEquals(period, "Period", "AY1516")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "OLASS");
              
            TestBase.Connection.GetRecord(fundingStreamPeriod, "EOF1417")
                .LookupFieldValueEquals(period, "Period", "EOF1417")
                .LookupFieldValueEquals(fundingStream, "Funding Stream Code", "EOF");
        }
    }
}
