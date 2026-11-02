namespace CrossDomain.Integration.Entities.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    [TestClass]
    public class DeliveryAllocation
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FlattenDeliverables_ShouldFlattenDeliverableHierArchicalStructure()
        {
            //Arrange
            allocationType alloc = new allocationType();

            var originalDeliverables = new List<contractDeliverableType>
            {
                new contractDeliverableType
                {
                    deliverable = new deliverableType
                    {
                        deliverableCode = 0
                    },
                    contractDeliverables = new List<contractDeliverableType>
                    {
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = 1
                            },
                            contractDeliverables = new List<contractDeliverableType>
                            {
                                new contractDeliverableType
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = 2
                                    }
                                },
                                new contractDeliverableType
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = 3
                                    }
                                }
                            }
                        },
                        new contractDeliverableType
                        {
                            deliverable = new deliverableType
                            {
                                deliverableCode = 4
                            },
                            contractDeliverables = new List<contractDeliverableType>
                            {
                                new contractDeliverableType
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = 5
                                    }
                                },
                                new contractDeliverableType
                                {
                                    deliverable = new deliverableType
                                    {
                                        deliverableCode = 6
                                    }
                                }
                            }
                        }
                    }
                },
                new contractDeliverableType
                {
                    deliverable = new deliverableType
                    {
                        deliverableCode = 7
                    }
                }

            };

            alloc.contractDeliverables = new List<contractDeliverableType>(originalDeliverables);

            //Act
            var flattenedList = alloc.FlattenDeliverables(alloc.contractDeliverables);

            //Assert
            originalDeliverables.ForEach(
                d =>
                {
                    Assert.IsTrue(flattenedList.Contains(d), "FlattenDeliverables didn't contain deliverable with id: " + d.deliverable.deliverableCode);
                });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void organisationReferenceType_GetUkprn_ShouldReturnUkprn()
        {
            const int expectedUkprn = 12345;

            // arrange
            organisationReferenceType contractorReference = new organisationReferenceType
            {
                alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                {
                    new alternativeOrganisationIdentifierType
                    {
                        OrganisationIdentifier = expectedUkprn.ToString(),
                        OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER
                    }
                }
            };

            // act
            int actualUkprn = contractorReference.GetUkprn();

            // assert
            Assert.AreEqual(expectedUkprn, actualUkprn);
        }
    }
}