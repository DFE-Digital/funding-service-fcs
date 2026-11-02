namespace ContractRequestDomain.Cfs.Tests.Feed
{
    using System.Collections.Generic;
    using System.Linq;
    using Cfs.Feed.Dtos;
    using ContractRequestDomain.Cfs.Feed.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;

    [TestClass]
    public class AtomPageTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AtomPageTransformer_ToOrderedAllocationNotifications_ShouldReturnCorrectlyTransformedValues()
        {
            // arrange
            AtomPage atomPage = new AtomPage
            {
                Link = new[]
                {
                    new AtomLink
                    {
                        Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=101",
                        Rel = "self"
                    }
                },
                AtomEntry = new[]
                {
                    new AtomEntry
                    {
                        Id = "ALLOC-1",
                        Content = new AtomContent
                        {
                            Allocation = new AtomAllocation
                            {
                                Provider = new AtomProvider { UkPrn = 12345 },
                                AllocationVersionNumber = 1
                            }
                        }
                    }
                }
            };

            // act
            IReadOnlyCollection<AllocationNotification> allocationNotifications = AtomPageTransformer.ToOrderedAllocationNotifications(atomPage);

            // assert
            AllocationNotification allocationNotification = allocationNotifications.Single();
            Assert.AreEqual("ALLOC-1", allocationNotification.AllocationId, "AllocationId not correctly transformed");
            Assert.AreEqual(1, allocationNotification.VersionNumber, "VersionNumber not correctly transformed");
            Assert.AreEqual(12345, allocationNotification.Ukprn, "Ukprn not correctly transformed");
            Assert.AreEqual(101, allocationNotification.FeedPageNumber, "FeedPageNumber not correctly transformed");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomPageTransformer_ToOrderedAllocationNotifications_ShouldReturnAllocationNotificationsWithProcessingStatusOfNew()
        {
            // arrange
            AtomPage atomPage = new AtomPage
            {
                Link = new[]
                {
                    new AtomLink
                    {
                        Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=101",
                        Rel = "self"
                    }
                },
                AtomEntry = new[]
                {
                    new AtomEntry
                    {
                        Id = "ALLOC-1",
                        Content = new AtomContent
                        {
                            Allocation = new AtomAllocation
                            {
                                Provider = new AtomProvider { UkPrn = 12345 },
                                AllocationVersionNumber = 1
                            }
                        }
                    }
                }
            };

            // act
            IReadOnlyCollection<AllocationNotification> allocationNotifications = AtomPageTransformer.ToOrderedAllocationNotifications(atomPage);

            // assert
            AllocationNotification allocationNotification = allocationNotifications.Single();
            Assert.AreEqual(ProcessingStatus.New, allocationNotification.Status, $"Status not set to {nameof(ProcessingStatus.New)}");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void AtomPageTransformer_ToOrderedAllocationNotifications_ShouldReturnAllocationNotificationsInReverseOrder()
        {
            // arrange
            AtomPage atomPage = new AtomPage
            {
                Link = new[]
                {
                    new AtomLink
                    {
                        Href = "https://pp-api-calculate-funding.education.gov.uk/api/v1/allocations/notifications?pageRef=101",
                        Rel = "self"
                    }
                },
                AtomEntry = new[]
                {
                    new AtomEntry
                    {
                        Id = "1",
                        Content = new AtomContent
                        {
                            Allocation = new AtomAllocation
                            {
                                Provider = new AtomProvider { UkPrn = 1 },
                                AllocationVersionNumber = 1
                            }
                        }
                    },
                    new AtomEntry
                    {
                        Id = "2",
                        Content = new AtomContent
                        {
                            Allocation = new AtomAllocation
                            {
                                Provider = new AtomProvider { UkPrn = 2 },
                                AllocationVersionNumber = 2
                            }
                        }
                    },
                    new AtomEntry
                    {
                        Id = "3",
                        Content = new AtomContent
                        {
                            Allocation = new AtomAllocation
                            {
                                Provider = new AtomProvider { UkPrn = 3 },
                                AllocationVersionNumber = 3
                            }
                        }
                    }
                }
            };

            // act
            IReadOnlyCollection<AllocationNotification> allocationNotifications = AtomPageTransformer.ToOrderedAllocationNotifications(atomPage);

            // assert
            Assert.AreEqual(3, allocationNotifications.Count, "Incorrect number of allocation notifications returned");
            Assert.AreEqual("3", allocationNotifications.ToArray()[0].AllocationId, "Incorrect ordering of allocation notifications returned");
            Assert.AreEqual("2", allocationNotifications.ToArray()[1].AllocationId, "Incorrect ordering of allocation notifications returned");
            Assert.AreEqual("1", allocationNotifications.ToArray()[2].AllocationId, "Incorrect ordering of allocation notifications returned");
        }
    }
}
