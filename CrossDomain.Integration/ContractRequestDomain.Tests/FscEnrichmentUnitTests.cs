//namespace ContractRequestDomain.Tests
//{
//    using System;
//    using Microsoft.VisualStudio.TestTools.UnitTesting;
//    using SFA.FCT.CrossDomain.Integration.Events;
//    using SFA.FCT.ContractRequestDomain.BusinessLogic;

//    [TestClass]
//    public class FscEnrichmentUnitTests
//    {
//        private FileValidationFscEnrichment _fscFileEnrichment;
//        [TestInitialize]
//        public void GetData()
//        {
//            _fscFileEnrichment = new FileValidationFscEnrichment();
//        }

//        [TestMethod, TestCategory("UnitTest")]
//        public void Check_FscReferenceData_CanNotBeRetrievedWithNullReference()
//        {
//            try
//            {
//                _fscFileEnrichment.Enrich(null);

//            }
//            catch (Exception ex)
//            {
//                Assert.IsTrue(ex.Message == "Control Sheet is missing");
//            }
//        }

//        [TestMethod, TestCategory("UnitTest")]
//        public void Check_FscReferenceData_CanNotBeRetrievedWithBlankReference()
//        {
//            try
//            {
//                _fscFileEnrichment.Enrich(new NewExcelUploadFileEvent());
//            }
//            catch (Exception ex)
//            {
//                Assert.IsTrue(ex.Message == "Control Sheet is missing");
//            }
//        }
//    }
//}
