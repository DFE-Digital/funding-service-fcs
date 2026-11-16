namespace SFA.FCT.Contracts.AcceptanceTests.Steps
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Extensions;
    using Infrastructure.DTO;
    using Infrastructure.Repositories;
    using Infrastructure.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using OrganisationDomain.Implementation.Mappers;
    using OrganisationDomain.Integration.DataStore.Model;
    using OrganisationDomain.Integration.Messages.Commands;
    using TechTalk.SpecFlow;
    using Utilities;
    using Xrm.TestFramework;
    using NUnit.Framework.Legacy;

    [Binding]
    public class OrganisationDomainSteps
    {
        [Given(@"the following Organisations exist in CRM")]
        public void TheFollowingOrganisationsExistInCrm(TransformedTable table)
        {
            CrmOrganisationRepository.AddOrUpdateOrganisations(table.Rows.Select(row =>
            {
                var org = new Account
                {
                    sfa_UKPRN = row["UKPRN"],
                    sfa_orgupin = row.ParseNullableString("UPIN"),
                    Name = row["Name"],
                    sfa_Status = CrmStatusRepository.GetStatus(row["Status"]),
                    sfa_companynumber = row.ParseNullableString("CompanyNumber"),
                    sfa_charitynumber = row.ParseNullableString("CharityNumber"),
                    Address1_Line1 = row.ParseNullableString("AddressLine1"),
                    Address1_Line2 = row.ParseNullableString("AddressLine2"),
                    Address1_Line3 = row.ParseNullableString("AddressLine3"),
                    Address1_Line4 = row.ParseNullableString("AddressLine4"),
                    Address1_Town = row.ParseNullableString("Town"),
                    Address1_County = row.ParseNullableString("County"),
                    Address1_PostCode = row.ParseNullableString("Postcode")
                };

                // do not touch Org ID unless present, legacy calls may not have value defined
                if (row.ContainsKey("Organisation ID"))
                {
                    org.sfa_OrganisationID = row.ParseNullableString("Organisation ID");
                }

                return org;
            }));
        }

        [Given(@"PaaS Organisation data has been replicated in CRM for the following UKPRNs")]
        public void GivenTheFollowingOrganisationsHaveBeenReplicatedInCRM(Table table)
        {
            CrmOrganisationRepository.AddOrUpdateOrganisations(table.Rows.Select(row =>
            {
                string ukprnString = row["UKPRN"];
                var org = OrganisationRepository.FindByUkprn(int.Parse(ukprnString));
                
                return new Account
                {
                    sfa_UKPRN = ukprnString,
                    sfa_orgupin = org.Upin.ToString(),
                    Name = org.TradingName,
                    sfa_Status = CrmStatusRepository.GetStatus(org.Status),
                    sfa_companynumber = org.CompanyRegistrationNumber,
                    sfa_charitynumber = org.CharityNumber,
                    Address1_Line1 = org.Address.Line1,
                    Address1_Line2 = org.Address.Line2,
                    Address1_Line3 = org.Address.Line3,
                    Address1_Line4 = org.Address.Line4,
                    Address1_Town = org.Address.Town,
                    Address1_County = org.Address.County,
                    Address1_PostCode = org.Address.Postcode,
                    sfa_OrganisationID = $"ORG{org.OrganisationId:0000000}"
                };
            }));
        }

        [Given(@"the following Organisations exist in the FCT Organisation Service")]
        public void TheFollowingOrganisationsExistInTheFctOrganisationService(TransformedTable table)
        {
            table.Rows.ForEach(row => OrganisationRepository.AddOrUpdateOrganisationForUkprn(
                ukprn: row.ParseInt("UKPRN"),
                setValues: org =>
                {
                    org.Ukprn = row.ParseInt("UKPRN");
                    org.Upin = row.ParseInt("UPIN");
                    org.TradingName = row["Name"];
                    org.SequenceNumber = row.ParseInt("SequenceNumber");
                    org.HasUkrlpBeenCalledSuccessfully = row.ContainsKey("UKRLPCalledOk") && row["UKRLPCalledOk"] == "Yes";
                    org.CompanyRegistrationNumber = row.ParseNullableString("CompanyNumber");
                    org.CharityNumber = row.ParseNullableString("CharityNumber");
                    org.Status = row["Status"];
                    org.Type = string.Empty;
                    org.Address.Line1 = row.ParseNullableString("AddressLine1");
                    org.Address.Line2 = row.ParseNullableString("AddressLine2");
                    org.Address.Line3 = row.ParseNullableString("AddressLine3");
                    org.Address.Line4 = row.ParseNullableString("AddressLine4");
                    org.Address.Town = row.ParseNullableString("Town");
                    org.Address.County = row.ParseNullableString("County");
                    org.Address.Postcode = row.ParseNullableString("Postcode");
                }));
        }

        [Given(@"the following Organisations exist in the CRM Organisations table")]
        public void GivenTheFollowingOrganisationsExistInTheCRM(Table table)
        {
             var orgDtos = table.Rows.Select(r => new OrganisationDto
             {
                 Ukprn = r["UKPRN"],
                 Upin = r["UPIN"],
                 LegalName = r["Name"],
                 CharityNumber = r.ParseNullableString("CharityNumber"),
                 CompanyNumber = r.ParseNullableString("CompanyNumber")
             });

            orgDtos.ForEach(CrmOrganisationRepository.CreateOrganisation);
        }

        [Given(@"there is no Organisation data in PaaS for the following UKPRNs")]
        [Given(@"there is no data in the FCT Organisation Service for the following Organisations")]
        public void GivenThereIsNoDataInTheFctOrganisationServiceForTheFollowingOrganisations(Table table)
        {
            OrganisationRepository.RemoveRangeByUkprn(table.Rows.Select(row => int.Parse(row["UKPRN"])));
        }

        [Given(@"there is no data in the UKRLP stub for the following Organisations")]
        public void GivenThereIsNoDataInTheUkrlpStubForTheFollowingOrganisations(Table table)
        {
            table.Rows.ForEach(row => UkrlpStubRepository.RemoveByUkprn(int.Parse(row["UKPRN"])));
        }

        [Given(@"the following active Organisations exist in the UKRLP stub")]
        public void GivenTheFollowingActiveOrganisationsExistInTheUkrlpStub(Table table)
        {
            table.Rows.ForEach(row => UkrlpStubRepository.Add(
                ukprn: int.Parse(row["UKPRN"]),
                companyNumber: row.ParseNullableString("CompanyNumber"),
                charityNumber: row.ParseNullableString("CharityNumber"),
                addressLine1: row.ParseNullableString("AddressLine1"),
                addressLine2: row.ParseNullableString("AddressLine2"),
                addressLine3: row.ParseNullableString("AddressLine3"),
                addressLine4: row.ParseNullableString("AddressLine4"),
                town: row.ParseNullableString("Town"),
                county: row.ParseNullableString("County"),
                postcode: row.ParseNullableString("Postcode")));
        }

        [When(@"the InitOrganisationUpdate command is sent")]
        public void TheInitOrganisationUpdateCommandIsSent()
        {
            MessageSendingBus.Send<InitOrganisationUpdate>("OrgService.Main", new InitOrganisationUpdate
            {
                ProcessId = "UpdateOrg1"
            });
        }

        [When(@"the system checks for updated organisations in UKRLP")]
        public void WhenTheSystemChecksForUpdatedOrganisationsInUkrlp()
        {
            MessageSendingBus.Send("OrgService.Main", new UpdateSupplementaryDataChangesCommand());
        }

        [Then(@"the Organisations are updated in CRM as follows")]
        public void TheOrganisationsAreUpdatedInCrmAsFollows(Table table)
        {
            int attemptNumber = 0;
            bool hasPassed = false;
            const int numAttemptsToAssert = 10;
            
            while (!hasPassed && attemptNumber < numAttemptsToAssert)
            {
                attemptNumber++;
                try
                {
                    System.Threading.Tasks.Task.Delay(TimeSpan.FromSeconds(20)).Wait();

                    XrmPackageEntity orgEntity = XrmService.Configuration.Entity("account");
                    XrmPackageEntity statusEntity = XrmService.Configuration.Entity("sfa_status");

                    foreach (TableRow row in table.Rows)
                    {
                        EntityReference statusEntityReference = CrmStatusRepository.GetStatus(row["Status"]);
                        string orgStatus = CrmOrganisationRepository.GetOrganisationStatusByName(row["Name"]);

                        ClassicAssert.AreEqual(row["Status"], orgStatus, "The org status is not correct");
                    }
                        
                    hasPassed = true;
                }
                catch (Exception)
                {
                    if (attemptNumber == numAttemptsToAssert)
                    {
                        throw;
                    }
                }
            }
        }

        [Given(@"the CRM Organisation table contains the following values")]
        [Then(@"the CRM Organisation table contains the following values")]
        [Then(@"the following Organisation details exist in the CRM Organisation table")]

        public void ThenTheCrmOrganisationTableContainsTheFollowingValues(Table table)
        {
            table.Rows.ForEach(row =>
            {
                CrmOrganisationInfo crmOrganisation = null;

                CheckResultPoller poller = new CheckResultPoller(checkResult: () =>
                {
                    crmOrganisation = CrmOrganisationRepository.GetOrganisationByUkprn(row["UKPRN"]);
                    return crmOrganisation != null;
                }, maxNumChecks: 5, waitIntervalSeconds: 2);

                bool hasMatchingOrganisationInCrm = poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsTrue(hasMatchingOrganisationInCrm, $"Failed to find organisation in CRM with UKPRN {row["UKPRN"]}");

                ClassicAssert.AreEqual(row["UPIN"], crmOrganisation.Upin, $"UPIN mismatch for UKPRN {row["UKPRN"]}");
                ClassicAssert.AreEqual(row["Name"], crmOrganisation.Name, $"Name mismatch for UKPRN {row["UKPRN"]}");
                ClassicAssert.AreEqual(row["Status"], crmOrganisation.Status, $"Status mismatch for UKPRN {row["UKPRN"]}");

                if (row.ContainsKey("CompanyNumber"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("CompanyNumber"), crmOrganisation.CompanyNumber, $"CompanyNumber mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("CharityNumber"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("CharityNumber"), crmOrganisation.CharityNumber, $"CharityNumber mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("AddressLine1"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine1"), crmOrganisation.Address.Line1, $"AddressLine1 mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("AddressLine2"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine2"), crmOrganisation.Address.Line2, $"AddressLine2 mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("AddressLine3"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine3"), crmOrganisation.Address.Line3, $"AddressLine3 mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("AddressLine4"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine4"), crmOrganisation.Address.Line4, $"AddressLine4 mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("Town"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("Town"), crmOrganisation.Address.Town, $"Town mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("County"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("County"), crmOrganisation.Address.County, $"County mismatch for UKPRN {row["UKPRN"]}");
                }
                if (row.ContainsKey("Postcode"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("Postcode"), crmOrganisation.Address.Postcode, $"Postcode mismatch for UKPRN {row["UKPRN"]}");
                }
            });
        }

        [Then(@"the following organisations do not exist in the CRM Organisation table")]
        public void ThenTheFollowingOrganisationsDoNotExistInTheCrmOrganisationTable(Table table)
        {
            table.Rows.ForEach(row =>
            {
                string ukprn = row["UKPRN"];
                CrmOrganisationInfo crmOrganisation = CrmOrganisationRepository.GetOrganisationByUkprn(ukprn);

                ClassicAssert.IsNull(crmOrganisation, $"Found organisation in CRM with UKPRN {ukprn}");
            });
        }

        [Then(@"the following Organisations exist in the FCT Organisation Service")]
        [Then(@"the following Organisation details exist in the FCT Organisation Service")]
        public void ThenTheFollowingOrganisationsExistInTheFctOrganisationService(Table table)
        {
            table.Rows.ForEach(row =>
            {
                int ukprn = int.Parse(row["UKPRN"]);
                string companyRegNumber = row["CompanyNumber"];

                Organisation orgInDb = null;

                CheckResultPoller poller = new CheckResultPoller(() =>
                {
                    orgInDb = OrganisationRepository.FindByUkprn(ukprn);
                    return orgInDb != null && orgInDb.CompanyRegistrationNumber == companyRegNumber;
                }, maxNumChecks: 10, waitIntervalSeconds: 2);

                poller.CheckResultAndWaitTillCompleteOrOutOfTime();

                ClassicAssert.IsNotNull(orgInDb, $"No organisation found in Organisation Service for UKPRN {ukprn}");

                if (row.ContainsKey("UPIN"))
                {
                    ClassicAssert.AreEqual(row.ParseInt("UPIN"), orgInDb.Upin, $"Mismatching UPIN value in Organisation Service for UKPRN {ukprn}");
                }

                ClassicAssert.AreEqual(row["Name"], orgInDb.TradingName, $"Mismatching Name in Organisation Service for UKPRN {ukprn}");

                if (row.ContainsKey("SequenceNumber"))
                {
                    ClassicAssert.AreEqual(row.ParseInt("SequenceNumber"), orgInDb.SequenceNumber, $"Mismatching SequenceNumber value in Organisation Service for UKPRN {ukprn}");
                }

                if (row.ContainsKey("Status"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("Status"), orgInDb.Status, $"Mismatching Status value in Organisation Service for UKPRN {ukprn}");
                }

                ClassicAssert.AreEqual(row.ParseNullableString("CompanyNumber"), orgInDb.CompanyRegistrationNumber, $"Mismatching CompanyNumber in Organisation Service for UKPRN {ukprn}");
                ClassicAssert.AreEqual(row.ParseNullableString("CharityNumber"), orgInDb.CharityNumber, $"Mismatching CharityNumber in Organisation Service for UKPRN {ukprn}");

                string ukrlpCalledOk = row.ParseNullableString("UKRLPCalledOk");
                if (ukrlpCalledOk != null)
                {
                    ClassicAssert.AreEqual(ukrlpCalledOk, orgInDb.HasUkrlpBeenCalledSuccessfully ? "Yes" : "No", $"Mismatching UKRLPCalledOk value in Organisation Service for UKPRN {ukprn}");
                }
                if (row.ContainsKey("AddressLine1"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine1"), orgInDb.Address.Line1, $"Mismatching AddressLine1 value in Organisation Service for UKPRN {ukprn}");
                }
                if (row.ContainsKey("AddressLine2"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine2"), orgInDb.Address.Line2, $"Mismatching AddressLine2 value in Organisation Service for UKPRN {ukprn}");
                }
                if (row.ContainsKey("AddressLine3"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine3"), orgInDb.Address.Line3, $"Mismatching AddressLine3 value in Organisation Service for UKPRN {ukprn}");
                }
                if (row.ContainsKey("AddressLine4"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("AddressLine4"), orgInDb.Address.Line4, $"Mismatching AddressLine4 value in Organisation Service for UKPRN {ukprn}");
                }
                if (row.ContainsKey("Town"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("Town"), orgInDb.Address.Town, $"Mismatching Town value in Organisation Service for UKPRN {ukprn}");
                }
                if (row.ContainsKey("County"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("County"), orgInDb.Address.County, $"Mismatching County value in Organisation Service for UKPRN {ukprn}");
                }
                if (row.ContainsKey("Postcode"))
                {
                    ClassicAssert.AreEqual(row.ParseNullableString("Postcode"), orgInDb.Address.Postcode, $"Mismatching Postcode value in Organisation Service for UKPRN {ukprn}");
                }

                organisation corporationSchemaOrg = new CpdsMapper().MapDbEntityToCorpSchema(orgInDb);
                string actualStatus = corporationSchemaOrg.organisationStatusRelationships
                    .FirstOrDefault(o => o.organisationStatus.organisationStatusScheme == organisationStatusSchemeType.LEGAL)?.organisationStatus?.organisationStatus;

                ClassicAssert.IsNotNull(actualStatus, $"No Status held in Organisation Service for UKPRN {ukprn}");
                ClassicAssert.AreEqual(row["Status"], actualStatus, $"Mismatching Status in Organisation Service for UKPRN {ukprn}");
            });
        }

        [Then(@"the following Organisations do not exist in the FCT Organisation Service")]
        public void ThenTheFollowingOrganisationsDoNotExistInTheFctOrganisationService(Table table)
        {
            table.Rows.ForEach(row =>
            {
                int ukprn = int.Parse(row["UKPRN"]);
                Organisation orgInDb = OrganisationRepository.FindByUkprn(ukprn);

                ClassicAssert.IsNull(orgInDb, $"Organisation found in Organisation Service for UKPRN {ukprn}");
            });
        }

        [Then(@"the following notifications of type '(.*)' related to the '(.*)' are present in CRM")]
        [Given(@"the following notifications of type '(.*)' related to the '(.*)' are present in CRM")]
        public void ThenWeHaveFollowingNotificationsRelatedToTheInCRM(string notificationType, string teamName, Table table)
        {
            sfa_notificationtype? notificationtype = ParseNotificationType(notificationType);
            ClassicAssert.IsNotNull(notificationtype, $"The notification type passed: {notificationType} in cannot be converted to a sfa_notificationtype");

            EntityReference teamEr = CrmTeamRepository.GetTeamEntityReference(teamName);
            
            var simpleNotifications = table.Rows.Select(r => new SimpleNotification(int.Parse(r["UKPRN"]), r["Name"], r["Message"],
                CrmOrganisationRepository.GetOrganisationEntityReferenceByUkprn(r["UKPRN"]))).ToList();

            simpleNotifications.ForEach(sn =>
            {
                ClassicAssert.IsNotNull(sn.ProviderEntityReference, $"This ukprn: {sn.Ukprn} does not relate to a provider");

                CheckResultPoller checkResultPoller = new CheckResultPoller(checkResult: () =>
                {
                    IReadOnlyCollection<Infrastructure.DTO.SimpleNotification> notifications = CrmNotificationRepository.GetNotificationsByTypeAndOwnerTeamAndProvider(
                        notificationtype.Value, teamEr, sn.ProviderEntityReference);
                    
                    return notifications.Any(n => n.NotificationText == sn.Message && n.NotificationName == sn.Name);
                },
                maxNumChecks: 10,
                waitIntervalSeconds: 6);

                bool isPresent = checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTimeWithGenericSqlErrorTolerance();
                ClassicAssert.IsTrue(isPresent, $"This notification is not present: {sn}");
            });
        }

        [Given(@"there are no CRM Notifications for the following UKPRNs")]
        public void GivenThereAreNoNotificationsForUKPRNForTheseUkprns(Table table)
        {
            table.Rows.Select(r => r["UKPRN"]).ForEach(CrmNotificationRepository.DeleteNotificationsForUkprn);
        }

        private static sfa_notificationtype? ParseNotificationType(string notificationType)
        {
            sfa_notificationtype result;
            if (Enum.TryParse(notificationType.Replace(" ", string.Empty), true, out result))
            {
                return result;
            }

            return null;
        }

        private class SimpleNotification
        {
            public SimpleNotification(int ukprn, string name, string message, EntityReference providerEntityReference)
            {
                Ukprn = ukprn;
                Name = name;
                Message = message;
                ProviderEntityReference = providerEntityReference;
            }

            public int Ukprn { get; }

            public string Name { get; }

            public string Message { get; }

            public EntityReference ProviderEntityReference { get; }

            public override string ToString()
            {
                return $"Ukprn: {Ukprn}, Notification Name: {Name}, Message: {Message}";
            }
        }
    }
}