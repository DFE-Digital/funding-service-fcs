namespace FCT.Operations.Cda.Tests.Repositories
{
    using System.Collections.Generic;
    using Cda.Repositories;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class CrmCdaRepositoryTests
    {
        [TestMethod, TestCategory("TechnicalExploration")]
        public void CrmCdaRepository_ShouldGetData()
        {
            var fsps = "AEBTO-CL1617,ANLA1617,16-18TRN1718,NCS-ASIST1718,NCS-I1718,ALLB1920,ALLF1920,NCS-C1920,AEBC-ASCL1920,16-18APPS1516,AGE1516,AAC1617," +
                       "AEBTO-TOL1617,AEBTO-LS1718,AEBTO-TOL1718,NMF1718,AGE1718,NCS-I2018,ALLB1819,NCS-C1819,AEBC-19TRN1920,NONLEVY2019,OLASS1516,AEBTO-LS1617," +
                       "OLASS1617,ALLBC1718,NCS-C1718,ANLAP2018,CLP1819,1619LR1819,ALLBC1819,AEBC1819,AEB-CL1819,AEB-LS1819,16-18TRN1920,AEB-CL1920,AEB-19TRLS1920," +
                       "AEB-ASLS1920,16-18NLAP-AS2019,EOF1417,ESF1420,24+ALLF1516,CL1516,ALLB1617,AEBC1718,AEB-TOL1718,NCS-FWL1718,16-18NLAP2018,16-18TRN1819," +
                       "AEB-TOL1819,NCS-DEV1819,ALLBC1920,AEB-19TRN1920,NLG1920";

            var rows = new CrmCdaRepository(new LocalConfig()).GetRows(new List<string> { fsps }, isLatestVersion: true).Result;
            Assert.IsTrue(rows.Count > 0);
        }
    }
}
