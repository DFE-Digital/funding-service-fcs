namespace FctServices.Test.ServiceTests
{
    using System;
    using System.Web.Services.Protocols;
    using DataContract.GatewayService;
    using MessageContract.GatewayService;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using ServiceContract.GatewayService;
    using ServiceImplementation.GatewayService;
    using Storage;

    [TestClass]
    public class GatewayServiceTests
    {
        private GatewayServiceContract _gatewayService;
        private GatewayServiceStubRepository _stubRepository;

        [TestInitialize]
        public void TestInitialize()
        {
            _gatewayService = new GatewayService();
            _stubRepository = new GatewayServiceStubRepository(new AzureTableStore());
            TestCleanup();
        }

        [TestCleanup]
        public void TestCleanup()
        {
            _stubRepository.Clear();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProvidersByUKPRN_ShouldReturnExpectedResponsesForUkprnInStubStorageAfterUpdating()
        {
            // arrange
            string ukprn = new Random().Next(1, 99999).ToString();

            // act
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = ukprn, Status = "NOTFOUND" });

            GProvByUKPRNResponse response1 = _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = ukprn
                    }
                }
            });

            // assert
            Assert.IsNotNull(response1, "Response was null.");
            Assert.IsFalse(response1.RawCPDSResponse.Contains("ES_ACTIVE"));

            // act
            GatewayServiceStubEntity storedEntity = _stubRepository.FindByUkprn(ukprn);
            storedEntity.Status = "ACTIVE";
            _stubRepository.Update(storedEntity);

            GProvByUKPRNResponse response2 = _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = ukprn
                    }
                }
            });

            // assert
            Assert.IsNotNull(response2, "Response was null.");
            Assert.IsTrue(response2.RawCPDSResponse.Contains("ES_ACTIVE"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProvidersByUKPRN_ShouldReturnExpectedResponseForInactiveUkprnInStubStorage()
        {
            // arrange
            string ukprn = new Random().Next(1, 99999).ToString();

            // act
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = ukprn, Status = "INACTIVE" });

            GProvByUKPRNResponse response1 = _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = ukprn
                    }
                }
            });

            // assert
            Assert.IsNotNull(response1, "Response was null.");
            Assert.IsTrue(response1.RawCPDSResponse.Contains("ES_INACTIVE"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProvidersByUKPRN_ShouldReturnExpectedResponseForActiveUkprnInStubStorage()
        {
            // arrange
            string ukprn = new Random().Next(1, 99999).ToString();

            // act
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = ukprn, Status = "ACTIVE" });

            GProvByUKPRNResponse response1 = _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = ukprn
                    }
                }
            });

            // assert
            Assert.IsNotNull(response1, "Response was null.");
            Assert.IsTrue(response1.RawCPDSResponse.Contains("ES_ACTIVE"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProvidersByUKPRN_ShouldReturnExpectedResponseForDissolvedUkprnInStubStorage()
        {
            // arrange
            string ukprn = new Random().Next(1, 99999).ToString();

            // act
            _stubRepository.Add(new GatewayServiceStubEntity { Ukprn = ukprn, Status = "DISSOLVED" });

            GProvByUKPRNResponse response1 = _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = ukprn
                    }
                }
            });

            // assert
            Assert.IsNotNull(response1, "Response was null.");
            Assert.IsTrue(response1.RawCPDSResponse.Contains("ES_DISSOLVED"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProvidersByUKPRN_ShouldReturnResponseForRangeOfPredefinedUkprns()
        {
            // arrange
            Action<string> assertResponse = ukprn =>
            {
                GProvByUKPRINRequest request = new GProvByUKPRINRequest
                {
                    UKPRNs = new UKPRNCollection
                    {
                        new UKPRN
                        {
                            UKPRNData = ukprn
                        }
                    }
                };

                GProvByUKPRNResponse response = _gatewayService.GetProvidersByUKPRN(request);
                Assert.IsNotNull(response, "Response was null.");
            };

            // act, assert
            assertResponse("10000000");
            assertResponse("10009986");
            assertResponse("10009987");
            assertResponse("10009988");
            assertResponse("78900201");
            assertResponse("78900203");
            assertResponse("78900299");
            assertResponse("88999994");
            assertResponse("88999995");
            assertResponse("99990001");
            assertResponse("99990002");
            assertResponse("99990003");
            assertResponse("99990004");
            assertResponse("99990005");
            assertResponse("99990087");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProvidersByUKPRN_ShouldReturnResponseForRandomUkprn()
        {
            // act
            GProvByUKPRNResponse response = _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = new Random().Next(1, 9999999).ToString()
                    }
                }
            });

            // assert
            Assert.IsNotNull(response);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        [ExpectedException(typeof (SoapException))]
        public void GatewayService_GetProvidersByUKPRN_ShouldThrowSoapExceptionForUkprn20000000()
        {
            // act
            _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = "20000000"
                    }
                }
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProviderSummaryByName_ShouldReturnResponse()
        {
            // arrange
            GatewayServiceContract gatewayService = new GatewayService();

            // act
            GProvByNameResponse response = gatewayService.GetProviderSummaryByName(new GProvByNameRequest());

            // assert
            Assert.IsNotNull(response);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GatewayService_GetProvidersByUpin_ShouldReturnResponse()
        {
            // arrange
            GatewayServiceContract gatewayService = new GatewayService();

            // act
            GProvByUPINResponse response = gatewayService.GetProvidersByUpin(new GProvByUPINRequest());

            // assert
            Assert.IsNotNull(response);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GatewayService_GetProvidersByUKPRN_ShouldReturnStatusOfLockedRestructureForPredefinedUkprn()
        {
            // arrange
            string ukprn = "10009989";

            // act
            GProvByUKPRNResponse response = _gatewayService.GetProvidersByUKPRN(new GProvByUKPRINRequest
            {
                UKPRNs = new UKPRNCollection
                {
                    new UKPRN
                    {
                        UKPRNData = ukprn
                    }
                }
            });

            // assert
            Assert.IsNotNull(response, "Response was null.");
            Assert.IsTrue(response.RawCPDSResponse.Contains("ES_LOCKED_RESTRUCTURE"), "Did not return the expected ExtStatus");
        }
    }
}
