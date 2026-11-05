namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Appendix_2
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore;
    using DataStore.Models;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix2;
    using Framework.Logging.NullObjects;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Newtonsoft.Json;
    using UnitTests.Common;
    using DocumentDefiner;
    using DocumentDefiner.Dtos;

    [TestClass]
    public class Appendix2DocumentCreatorTests
    {

        private const string xml_10003709_MAIN999_v2 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ctr:contract schemaVersion=\"8.00\" xsi:schemaLocation=\"contract D:\\TFS\\FCT\\Main\\Corporate\\Schemas\\contract_corporate_schema.xsd\" xmlns:ctr=\"urn:sfa:schemas:contract\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><ctr:contracts><ctr:contract><ctr:period><ctr:periodType><ctr:periodTypeCode>AY</ctr:periodTypeCode><ctr:periodTypeName>ACADEMIC YEAR</ctr:periodTypeName></ctr:periodType><ctr:period>1516</ctr:period><ctr:startDate>2015-08-01</ctr:startDate><ctr:endDate>2016-07-31</ctr:endDate></ctr:period><ctr:contractAllocations><ctr:contractAllocation><ctr:period><ctr:periodType><ctr:periodTypeCode>AY</ctr:periodTypeCode><ctr:periodTypeName>ACADEMIC YEAR</ctr:periodTypeName></ctr:periodType><ctr:period>1516</ctr:period><ctr:startDate>2015-08-01</ctr:startDate><ctr:endDate>2016-07-31</ctr:endDate></ctr:period><ctr:fundingStream><ctr:fundingStreamCode>16-18 APPS</ctr:fundingStreamCode><ctr:fundingStreamName /><ctr:fundingTypeCode>1</ctr:fundingTypeCode><ctr:fundingStreamShortCode>16-18 </ctr:fundingStreamShortCode></ctr:fundingStream><ctr:contractDeliverables><ctr:contractDeliverable><ctr:deliverable><ctr:fundingStreamCode>16-18 APPS</ctr:fundingStreamCode><ctr:deliverableCode>1</ctr:deliverableCode></ctr:deliverable><ctr:contractDeliverablePeriods><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>8</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>9</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>111321.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>10</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>73190.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>11</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>80871.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>12</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>28201.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>1</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>52171.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>2</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>94281.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>3</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>93872.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>4</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>94706.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>5</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>63002.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>6</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>31959.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>7</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod></ctr:contractDeliverablePeriods><ctr:deliverableDescription>Total 16-18 Funding</ctr:deliverableDescription></ctr:contractDeliverable><ctr:contractDeliverable><ctr:deliverable><ctr:fundingStreamCode>16-18 APPS</ctr:fundingStreamCode><ctr:deliverableCode>3</ctr:deliverableCode></ctr:deliverable><ctr:contractDeliverablePeriods><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>8</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>9</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>20717.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>10</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>12640.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>11</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>13418.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>12</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>10970.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>1</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>16837.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>2</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>18305.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>3</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>25843.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>4</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>28266.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>5</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>24650.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>6</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>15756.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>7</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod></ctr:contractDeliverablePeriods><ctr:deliverableDescription>16-18 Traineeships Total Funding</ctr:deliverableDescription></ctr:contractDeliverable><ctr:contractDeliverable><ctr:deliverable><ctr:fundingStreamCode>16-18 APPS</ctr:fundingStreamCode><ctr:deliverableCode>4</ctr:deliverableCode></ctr:deliverable><ctr:contractDeliverablePeriods><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>8</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>9</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>20717.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>10</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>12640.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>11</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>13418.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>12</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>10970.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>1</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>16837.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>2</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>18305.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>3</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>25843.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>4</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>28266.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>5</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>24650.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>6</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>15756.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>7</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod></ctr:contractDeliverablePeriods><ctr:deliverableDescription>16-18 Traineeships Programme Funding</ctr:deliverableDescription></ctr:contractDeliverable><ctr:contractDeliverable><ctr:deliverable><ctr:fundingStreamCode>16-18 APPS</ctr:fundingStreamCode><ctr:deliverableCode>5</ctr:deliverableCode></ctr:deliverable><ctr:contractDeliverablePeriods><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>8</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>9</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>10</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>11</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2015</ctr:year><ctr:period>12</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>1</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>2</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>3</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>4</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>5</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>6</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod><ctr:contractDeliverablePeriod><ctr:year>2016</ctr:year><ctr:period>7</ctr:period><ctr:periodType><ctr:periodTypeCode>CM</ctr:periodTypeCode><ctr:periodTypeName>CALENDAR MONTH</ctr:periodTypeName></ctr:periodType><ctr:plannedValue>0.00</ctr:plannedValue></ctr:contractDeliverablePeriod></ctr:contractDeliverablePeriods><ctr:deliverableDescription>16-18 Traineeships Bursary Funding</ctr:deliverableDescription></ctr:contractDeliverable></ctr:contractDeliverables><ctr:contractAllocationNumber>16AP-77</ctr:contractAllocationNumber><ctr:description>16-18 Apprenticeships</ctr:description><ctr:hierarchyType>CONTRACT ALLOCATION</ctr:hierarchyType><ctr:fundingStreamPeriodCode>16-18APPS1516</ctr:fundingStreamPeriodCode><ctr:startDate>2015-09-05</ctr:startDate><ctr:endDate>2016-06-17</ctr:endDate></ctr:contractAllocation></ctr:contractAllocations><ctr:contractNumber>MAIN-999</ctr:contractNumber><ctr:contractVersionNumber>2</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10003709</ctr:ukprn><ctr:legalName>KNOWSLEY METROPOLITAN BOROUGH COUNCIL</ctr:legalName></ctr:contractor><ctr:hierarchyType>CONTRACT</ctr:hierarchyType><ctr:startDate>2015-09-05</ctr:startDate><ctr:endDate>2016-06-17</ctr:endDate><ctr:contractStatus><ctr:status>DRAFT</ctr:status><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus></ctr:contract></ctr:contracts><ctr:fundingType><ctr:fundingTypeCode>MAIN</ctr:fundingTypeCode><ctr:fundingTypeName /></ctr:fundingType><ctr:contractNumber>SFA-888</ctr:contractNumber><ctr:contractVersionNumber>2</ctr:contractVersionNumber><ctr:contractor><ctr:organisationIdentifier>0</ctr:organisationIdentifier><ctr:ukprn>10003709</ctr:ukprn><ctr:legalName>KNOWSLEY METROPOLITAN BOROUGH COUNCIL</ctr:legalName></ctr:contractor><ctr:hierarchyType>MASTER CONTRACT</ctr:hierarchyType><ctr:contractStatus><ctr:status>DRAFT</ctr:status><ctr:parentStatus>DRAFT</ctr:parentStatus></ctr:contractStatus></ctr:contract>";

        private const string xml_10003709_MAIN999_v2_docgen =
            "<?xml version=\"1.0\"?><DocumentGenerationRequest xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns=\"http://sfa.bis.gov.uk/fct\"><TemplateContainer>document-template-dev</TemplateContainer><TemplateFilename>A2_16-18APPS1516_2015-08-01.docx</TemplateFilename><GroupId>16AP-77</GroupId><MergeData><MergeFields><MergeField><Name>DocumentTitle</Name><Value>16-18 Apprenticeships</Value></MergeField><MergeField><Name>OrgName</Name><Value>KNOWSLEY METROPOLITAN BOROUGH COUNCIL</Value></MergeField><MergeField><Name>MasterContractRef</Name><Value>SFA-888</Value></MergeField><MergeField><Name>ContractRef</Name><Value>MAIN-999 v2</Value></MergeField><MergeField><Name>UKPRN</Name><Value>10003709</Value></MergeField><MergeField><Name>HeaderText</Name><Value /></MergeField><MergeField><Name>AllocationStartDate</Name><Value>2015-09-05</Value></MergeField><MergeField><Name>AllocationEndDate</Name><Value>2016-06-17</Value></MergeField><MergeField><Name>AllocationContractRef</Name><Value>16AP-77</Value></MergeField><MergeField><Name>SpecificationTitle</Name></MergeField><MergeField><Name>LEP</Name></MergeField><MergeField><Name>TenderSpecificationRef</Name></MergeField><MergeField><Name>LOT</Name><Value>N/A</Value></MergeField><MergeField><Name>Agreement</Name></MergeField><MergeField><Name>DeliveryOrgName</Name></MergeField><MergeField><Name>UPIN</Name></MergeField><MergeField><Name>H1</Name><Value>Aug 2015</Value></MergeField><MergeField><Name>H2</Name><Value>Sep 2015</Value></MergeField><MergeField><Name>H3</Name><Value>Oct 2015</Value></MergeField><MergeField><Name>H4</Name><Value>Nov 2015</Value></MergeField><MergeField><Name>H5</Name><Value>Dec 2015</Value></MergeField><MergeField><Name>H6</Name><Value>Jan 2016</Value></MergeField><MergeField><Name>H7</Name><Value>Feb 2016</Value></MergeField><MergeField><Name>H8</Name><Value>Mar 2016</Value></MergeField><MergeField><Name>H9</Name><Value>Apr 2016</Value></MergeField><MergeField><Name>H10</Name><Value>May 2016</Value></MergeField><MergeField><Name>H11</Name><Value>Jun 2016</Value></MergeField><MergeField><Name>H12</Name><Value>Jul 2016</Value></MergeField></MergeFields><RepeatingSections><RepeatingSection><Name>MainTable</Name><Rows><Row><MergeFields><MergeField><Name>Name</Name><Value>Total 16-18 Apprenticeships Funding</Value></MergeField><MergeField><Name>CV</Name><Value>Cash (£)</Value></MergeField><MergeField><Name>Cash</Name><Value>723574.00</Value></MergeField><MergeField><Name>P1</Name><Value>0.00</Value></MergeField><MergeField><Name>P2</Name><Value>111321.00</Value></MergeField><MergeField><Name>P3</Name><Value>73190.00</Value></MergeField><MergeField><Name>P4</Name><Value>80871.00</Value></MergeField><MergeField><Name>P5</Name><Value>28201.00</Value></MergeField><MergeField><Name>P6</Name><Value>52171.00</Value></MergeField><MergeField><Name>P7</Name><Value>94281.00</Value></MergeField><MergeField><Name>P8</Name><Value>93872.00</Value></MergeField><MergeField><Name>P9</Name><Value>94706.00</Value></MergeField><MergeField><Name>P10</Name><Value>63002.00</Value></MergeField><MergeField><Name>P11</Name><Value>31959.00</Value></MergeField><MergeField><Name>P12</Name><Value>0.00</Value></MergeField><MergeField><Name>UnitCost</Name><Value>N/A</Value></MergeField></MergeFields><RepeatingSection><Rows /></RepeatingSection></Row><Row><MergeFields><MergeField><Name>Name</Name><Value>^tof which 16-18 Traineeships Programme Funding</Value></MergeField><MergeField><Name>CV</Name><Value>Cash (£)</Value></MergeField><MergeField><Name>Cash</Name><Value>187402.00</Value></MergeField><MergeField><Name>P1</Name><Value>0.00</Value></MergeField><MergeField><Name>P2</Name><Value>20717.00</Value></MergeField><MergeField><Name>P3</Name><Value>12640.00</Value></MergeField><MergeField><Name>P4</Name><Value>13418.00</Value></MergeField><MergeField><Name>P5</Name><Value>10970.00</Value></MergeField><MergeField><Name>P6</Name><Value>16837.00</Value></MergeField><MergeField><Name>P7</Name><Value>18305.00</Value></MergeField><MergeField><Name>P8</Name><Value>25843.00</Value></MergeField><MergeField><Name>P9</Name><Value>28266.00</Value></MergeField><MergeField><Name>P10</Name><Value>24650.00</Value></MergeField><MergeField><Name>P11</Name><Value>15756.00</Value></MergeField><MergeField><Name>P12</Name><Value>0.00</Value></MergeField><MergeField><Name>UnitCost</Name><Value>N/A</Value></MergeField></MergeFields><RepeatingSection><Rows /></RepeatingSection></Row><Row><MergeFields><MergeField><Name>Name</Name><Value>^tof which 16-18 Traineeships Bursary Funding</Value></MergeField><MergeField><Name>CV</Name><Value>Cash (£)</Value></MergeField><MergeField><Name>Cash</Name><Value>0.00</Value></MergeField><MergeField><Name>P1</Name><Value>0.00</Value></MergeField><MergeField><Name>P2</Name><Value>0.00</Value></MergeField><MergeField><Name>P3</Name><Value>0.00</Value></MergeField><MergeField><Name>P4</Name><Value>0.00</Value></MergeField><MergeField><Name>P5</Name><Value>0.00</Value></MergeField><MergeField><Name>P6</Name><Value>0.00</Value></MergeField><MergeField><Name>P7</Name><Value>0.00</Value></MergeField><MergeField><Name>P8</Name><Value>0.00</Value></MergeField><MergeField><Name>P9</Name><Value>0.00</Value></MergeField><MergeField><Name>P10</Name><Value>0.00</Value></MergeField><MergeField><Name>P11</Name><Value>0.00</Value></MergeField><MergeField><Name>P12</Name><Value>0.00</Value></MergeField><MergeField><Name>UnitCost</Name><Value>N/A</Value></MergeField></MergeFields><RepeatingSection><Rows /></RepeatingSection></Row><Row><MergeFields><MergeField><Name>Name</Name><Value>^bTotal Funding¶</Value></MergeField><MergeField><Name>CV</Name><Value>Cash (£)</Value></MergeField><MergeField><Name>Cash</Name><Value>187402.00</Value></MergeField><MergeField><Name>P1</Name><Value>0.00</Value></MergeField><MergeField><Name>P2</Name><Value>20717.00</Value></MergeField><MergeField><Name>P3</Name><Value>12640.00</Value></MergeField><MergeField><Name>P4</Name><Value>13418.00</Value></MergeField><MergeField><Name>P5</Name><Value>10970.00</Value></MergeField><MergeField><Name>P6</Name><Value>16837.00</Value></MergeField><MergeField><Name>P7</Name><Value>18305.00</Value></MergeField><MergeField><Name>P8</Name><Value>25843.00</Value></MergeField><MergeField><Name>P9</Name><Value>28266.00</Value></MergeField><MergeField><Name>P10</Name><Value>24650.00</Value></MergeField><MergeField><Name>P11</Name><Value>15756.00</Value></MergeField><MergeField><Name>P12</Name><Value>0.00</Value></MergeField></MergeFields><RepeatingSection><Rows /></RepeatingSection></Row></Rows></RepeatingSection></RepeatingSections></MergeData></DocumentGenerationRequest>";
        
        private const string templateName = "A2_16-18APPS1516_2015-08-01.docx";

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatDocumentPartIsRequiredFor1618APPS()
        {
            contract masterContract = TestHelpers.GetObjectFromXml<contract>(xml_10003709_MAIN999_v2);

            Mock<IDocumentConfigurationSource> configMock = new Mock<IDocumentConfigurationSource>();
            configMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns<contractAllocationsContractAllocation>(ca => ca.fundingStream.fundingStreamCode != "OTHER")
                .Verifiable();

            Appendix2DocumentCreator classUnderTest = new Appendix2DocumentCreator(null, configMock.Object, Mock.Of<IFundingStreamPeriodRepository>());
            Assert.IsTrue(classUnderTest.IsDocumentPartRequired(masterContract.contracts.First()));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestThatDocumentPartIsNotRequiredForOtherForAppendix2_1618APPS()
        {
            contract masterContract = TestHelpers.GetObjectFromXml<contract>(xml_10003709_MAIN999_v2.Replace("<ctr:fundingStream><ctr:fundingStreamCode>16-18 APPS</ctr:fundingStreamCode>", "<ctr:fundingStream><ctr:fundingStreamCode>OTHER</ctr:fundingStreamCode>"));

            Mock<IDocumentConfigurationSource> configMock = new Mock<IDocumentConfigurationSource>();
            configMock
                .Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns<contractAllocationsContractAllocation>(ca => ca.fundingStream.fundingStreamCode != "OTHER")
                .Verifiable();

            Appendix2DocumentCreator classUnderTest = new Appendix2DocumentCreator(null, configMock.Object, Mock.Of<IFundingStreamPeriodRepository>());
            Assert.IsFalse(classUnderTest.IsDocumentPartRequired(masterContract.contracts.First()));

            configMock.Verify(m => m.IsFundingAgreementRequiredForAllocation(It.Is<contractAllocationsContractAllocation>(ca => ca.fundingStream.fundingStreamCode == "OTHER")), Times.Once);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void TestIsHeaderRequiredForAppendix2_1618APPS()
        {
            TestIsHeaderRequired<Appendix2DocumentCreator>(false);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void TestRequiredHeaderDocumentNameForAppendix2_1618APPS()
        {
            Assert.AreEqual(Appendix2HeaderCreator.HeaderName,
                new Appendix2DocumentCreator(null,
                        DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories(),
                        Mock.Of<IFundingStreamPeriodRepository>())
                    .RequiredHeaderDocumentName);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_ProcuredNla_ShouldCreateExtraPageInAddition()
        {
            // Arrange
            var templateContainer = ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];

            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                "Resources.corpContractNla.json"))
            {
                using (StreamReader sr = new StreamReader(resource.Stream))
                {
                    contract c = JsonConvert.DeserializeObject<contract>(sr.ReadToEnd());

                    AzureStorageWrapper storageWrapper = new AzureStorageWrapper();

                    using (var context = new DocumentsDomainDbContext())
                    {
                        IDocumentConfigurationSource config =
                            new DocumentConfigurationSource(new FundingStreamPeriodRepository(context),
                                new FspDeliverableRepository(context), new FundingTypeFundingPeriodRepository(context));

                        Appendix2DocumentCreator creator =
                            new Appendix2DocumentCreator(
                                new TemplateRepository(storageWrapper) {Logger = new LoggerNullObject()}, config, new FundingStreamPeriodRepository(context));

                        // Act
                        IDictionary<string, DocumentGenerationRequest> req =
                            creator.SupplyDocumentGenerationRequest(c.parentContractNumber, c, templateContainer);

                        // Assert
                        Assert.AreEqual(6, req.Keys.Count, "Incorrect number of pages generated");
                        var repeatingSections = req.Values.SelectMany(v => v.MergeData.RepeatingSections).ToList();

                        repeatingSections.ForEach(
                            rs =>
                            {
                                Assert.AreEqual(2, rs.Rows.Count, "Incorrect number of rows in repeating section"); // Deliverable row & Totals row
                                Assert.AreEqual(16, rs.Rows.First().MergeFields.Count, "Incorrect number of merge fields in deliverable rows"); // 12 month values, UnitCost, Name, CashCV and Cash
                                Assert.AreEqual(15, rs.Rows.Last().MergeFields.Count, "Incorrect number of merge fields in total rows"); // 12 month values, Name, CashCV and Cash (Totals rows)
                            });

                        //Assert.IsTrue(repeatingSections.All(rs => rs.Rows.Count == 2),
                        //    "Incorrect number of rows in repeating section"); 
                        //Assert.IsTrue(repeatingSections.All(rs => rs.Rows.First().MergeFields.Count == 16),
                        //    "Incorrect number of merge fields in deliverable rows"); 
                        //Assert.IsTrue(repeatingSections.All(rs => rs.Rows.Last().MergeFields.Count == 15),
                        //    "Incorrect number of merge fields in totals rows"); 
                    }
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void Appendix2DocumentCreator_ProcuredNla_ShouldCreateFinancialYearHeadings()
        {
            // arrange
            string templateContainer = ConfigurationManager.AppSettings["DocumentGeneration.TemplateContainer"];
            contract contract = TestResource.FromJson<contract>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", "Resources.corpContractNla.json");
            AzureStorageWrapper storageWrapper = new AzureStorageWrapper();

            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                IDocumentConfigurationSource config = new DocumentConfigurationSource(
                    new FundingStreamPeriodRepository(context),
                    new FspDeliverableRepository(context),
                    new FundingTypeFundingPeriodRepository(new DocumentsDomainDbContext()));

                Appendix2DocumentCreator creator = new Appendix2DocumentCreator(
                    new TemplateRepository(storageWrapper)
                    {
                        Logger = new LoggerNullObject()
                    }, config, new FundingStreamPeriodRepository(context));

                // act
                IDictionary<string, DocumentGenerationRequest> requests = creator.SupplyDocumentGenerationRequest(contract.parentContractNumber, contract, templateContainer);

                // assert
                List<MergeFieldType> firstRequestMergeFields = requests["2001-TEST TRAINING COLLEGE-001-YNLP-20180101-01"].MergeData.MergeFields;
                Assert.AreEqual("Apr 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H1")?.Value);
                Assert.AreEqual("May 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H2")?.Value);
                Assert.AreEqual("Jun 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H3")?.Value);
                Assert.AreEqual("Jul 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H4")?.Value);
                Assert.AreEqual("Aug 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H5")?.Value);
                Assert.AreEqual("Sep 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H6")?.Value);
                Assert.AreEqual("Oct 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H7")?.Value);
                Assert.AreEqual("Nov 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H8")?.Value);
                Assert.AreEqual("Dec 2017", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H9")?.Value);
                Assert.AreEqual("Jan 2018", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H10")?.Value);
                Assert.AreEqual("Feb 2018", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H11")?.Value);
                Assert.AreEqual("Mar 2018", firstRequestMergeFields.SingleOrDefault(mf => mf.Name == "H12")?.Value);

                List<MergeFieldType> secondRequestMergeFields = requests["2001-TEST TRAINING COLLEGE-001-YNLP-20180101-02"].MergeData.MergeFields;
                Assert.AreEqual("Apr 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H1")?.Value);
                Assert.AreEqual("May 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H2")?.Value);
                Assert.AreEqual("Jun 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H3")?.Value);
                Assert.AreEqual("Jul 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H4")?.Value);
                Assert.AreEqual("Aug 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H5")?.Value);
                Assert.AreEqual("Sep 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H6")?.Value);
                Assert.AreEqual("Oct 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H7")?.Value);
                Assert.AreEqual("Nov 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H8")?.Value);
                Assert.AreEqual("Dec 2018", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H9")?.Value);
                Assert.AreEqual("Jan 2019", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H10")?.Value);
                Assert.AreEqual("Feb 2019", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H11")?.Value);
                Assert.AreEqual("Mar 2019", secondRequestMergeFields.SingleOrDefault(mf => mf.Name == "H12")?.Value);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_1619FUND_ShouldNotBeRequiredIfDeliveryOrgIsSameAsContractorUkprn()
        {
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetByKey(It.IsAny<string>())).Returns(
                new DataStore.Models.FundingStreamPeriod(string.Empty, string.Empty, 0, true, false, string.Empty, string.Empty, string.Empty, string.Empty));

            IDocumentConfigurationSource config = new DocumentConfigurationSource(fspRepositoryMock.Object, Mock.Of<IFspDeliverableRepository>(),
                Mock.Of<IFundingTypeFundingPeriodRepository>());

            var contract = GetEfaContract();

            var docCreator = new Appendix2DocumentCreator(null, config, Mock.Of<IFundingStreamPeriodRepository>());
            Assert.IsFalse(docCreator.IsDocumentPartRequired(contract.contracts[0]));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_1619FUND_ShouldBeRequiredIfSingleDeliveryOrgIsNotSameAsContractorUkprn()
        {
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetByKey(It.IsAny<string>())).Returns(
                new DataStore.Models.FundingStreamPeriod(string.Empty, string.Empty, 0, true, false, string.Empty, string.Empty, string.Empty, string.Empty));

            IDocumentConfigurationSource config = new DocumentConfigurationSource(fspRepositoryMock.Object,
                Mock.Of<IFspDeliverableRepository>(), Mock.Of<IFundingTypeFundingPeriodRepository>());

            var contract = GetEfaContract();
            contract.contracts[0].contractAllocations.First().DeliveryOrganisation = "87654321";

            var docCreator = new Appendix2DocumentCreator(null, config, Mock.Of<IFundingStreamPeriodRepository>());
            Assert.IsTrue(docCreator.IsDocumentPartRequired(contract.contracts[0]));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_1619FUND_ShouldBeRequiredIfADeliveryOrgIsNotSameAsContractorUkprn()
        {
            Mock<IFundingStreamPeriodRepository> fspRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepositoryMock.Setup(m => m.GetByKey(It.IsAny<string>())).Returns(
                new DataStore.Models.FundingStreamPeriod(string.Empty, string.Empty, 0, true, false, string.Empty, string.Empty, string.Empty, string.Empty));

            IDocumentConfigurationSource config = new DocumentConfigurationSource(fspRepositoryMock.Object,
                Mock.Of<IFspDeliverableRepository>(),
                Mock.Of<IFundingTypeFundingPeriodRepository>());

            var contract = GetEfaContractWithMultipleDeliveryOrgs();

            var docCreator = new Appendix2DocumentCreator(null, config, Mock.Of<IFundingStreamPeriodRepository>());
            Assert.IsTrue(docCreator.IsDocumentPartRequired(contract.contracts[0]));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_ShouldCreateResponseWhenTheDeliveryOrgAndFspTogetherAreUnique()
        {
            // arrange
            Mock<IDocumentConfigurationSource> docConfigSourceMock = new Mock<IDocumentConfigurationSource>();
            docConfigSourceMock.Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>())).Returns(
                true);
            docConfigSourceMock.Setup(m => m.GetDeliverableConfigurationForFundingAgreement(It.IsAny<contractAllocationsContractAllocation>(), It.IsAny<int>())).Returns(
                new DeliverableConfiguration());
            docConfigSourceMock.Setup(m => m.GetFundingAgreementTemplateNamesForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>())).Returns(
                new FundingAgreementTemplate("", ""));
            docConfigSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, false));
            // we need to return a display order that is linked to the fsp (same fsp, same order)
            docConfigSourceMock.Setup(m => m.GetFundingStreamPeriodDisplayOrder(It.IsAny<contractAllocationsContractAllocation>())).Returns(
                (contractAllocationsContractAllocation a ) => a.fundingStreamPeriodCode.GetHashCode());

            Mock<IFundingStreamPeriodRepository> FundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            FundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1" });

            FundingStreamPeriodRepositoryMock.Setup(r => r.GetFspGroups(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<FSPGroup>());

            var docCreator = new Appendix2DocumentCreator(Mock.Of<ITemplateRepository>(),
                docConfigSourceMock.Object,
                FundingStreamPeriodRepositoryMock.Object);

            contractType contract = GetContractFromMessageInFile();

            // act
            IDictionary<string, DocumentGenerationRequest> documentGenerationRequests = docCreator.SupplyDocumentGenerationRequest("", contract, "");

            // assert
            Assert.IsNotNull(documentGenerationRequests);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_SupplyDocumentGenerationRequest_ShouldPopulateMergeFieldFSPGroup()
        {
            // arrange
            var docConfigSourceMock = new Mock<IDocumentConfigurationSource>();
            docConfigSourceMock.Setup(m => m.IsFundingAgreementRequiredForAllocation(It.IsAny<contractAllocationsContractAllocation>()))
                .Returns(true);
            docConfigSourceMock.Setup(m => m.GetDeliverableConfigurationForFundingAgreement(It.IsAny<contractAllocationsContractAllocation>(), It.IsAny<int>()))
                .Returns(new DeliverableConfiguration());
            docConfigSourceMock.Setup(m => m.GetFundingAgreementTemplateNamesForAllocation(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingAgreementTemplate("", ""));
            // we need to return a display order that is linked to the fsp (same fsp, same order)
            docConfigSourceMock.Setup(m => m.GetFundingStreamPeriodDisplayOrder(It.IsAny<contractAllocationsContractAllocation>())).Returns(
                (contractAllocationsContractAllocation a) => a.fundingStreamPeriodCode.GetHashCode());
            docConfigSourceMock
                .Setup(m => m.GetFundingTypeFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new FundingTypeFundingPeriod(String.Empty, String.Empty, false));

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(m => m.GetFspGroupDisplayNames(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<string> { "FSPGroup1" });

            fundingStreamPeriodRepositoryMock.Setup(r => r.GetFspGroups(It.IsAny<IReadOnlyCollection<string>>()))
                .Returns(new List<FSPGroup>());

            var docCreator = new Appendix2DocumentCreator(Mock.Of<ITemplateRepository>(),
                docConfigSourceMock.Object,
                fundingStreamPeriodRepositoryMock.Object);

            var contract = GetContractFromMessageInFile();

            // act
            var documentGenerationRequests = docCreator.SupplyDocumentGenerationRequest("", contract, "");

            // assert
            Assert.IsNotNull(documentGenerationRequests);

            var mergeData = documentGenerationRequests.Values.SelectMany(v => v.MergeData.MergeFields);
            var mergeFieldFspGroup = mergeData.First(mf => mf.Name == "FSPGroup").Value;

            Assert.AreEqual("FSPGroup1", mergeFieldFspGroup, "MergeField FSPGroup is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_1619FUND_ShouldProduceNoPaymentSchedulesForContractWithNoDeliveryOrgs()
        {
            IDocumentConfigurationSource config =
                DocumentConfigurationSourceTests.GetDocumentConfigurationSourceWithMockRepositories();

            var contract = GetEfaContractWithMultipleDeliveryOrgs();
            contract.contracts[0].contractAllocations.ForEach(ca => ca.DeliveryOrganisation = "");

            var docCreator = new Appendix2DocumentCreator(null, config, Mock.Of<IFundingStreamPeriodRepository>());
            Assert.IsFalse(docCreator.IsDocumentPartRequired(contract));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_GetFundingAgreementTemplateNamesForAllocation_ShouldGetFromFspRepositoryWhenStandardCase()
        {
            // arrange
            const string fsp = "16-18TRN1920";
            const string fundingType = "MAIN";

            Mock<IFundingStreamPeriodRepository> fspRepMock = new Mock<IFundingStreamPeriodRepository>();
            fspRepMock.Setup(r => r.GetByKey(fsp)).Returns(FspFactory.GetDefaultFsp);
                   
            DocumentConfigurationSource documentConfigurationSource = new DocumentConfigurationSource(
                fspRepMock.Object, 
                Mock.Of<IFspDeliverableRepository>(),
                Mock.Of<IFundingTypeFundingPeriodRepository>());

            // act
            documentConfigurationSource.GetFundingAgreementTemplateNamesForAllocation("", fsp, fundingType);
            
            // assert
            fspRepMock.Verify(r => r.GetByKey(fsp), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void Appendix2DocumentCreator_GetFundingAgreementTemplateNamesForAllocation_ShouldGetHardCodedMainTemplate_WhenMainstreamAndApps()
        {
            // arrange
            DocumentConfigurationSource documentConfigurationSource = new DocumentConfigurationSource(
                Mock.Of<IFundingStreamPeriodRepository>(),
                Mock.Of<IFspDeliverableRepository>(),
                Mock.Of<IFundingTypeFundingPeriodRepository>());

            // act
            FundingAgreementTemplate template1920 =
                documentConfigurationSource.GetFundingAgreementTemplateNamesForAllocation("APPS", "APPS1920", "MAIN");
            FundingAgreementTemplate template2021 =
                documentConfigurationSource.GetFundingAgreementTemplateNamesForAllocation("APPS", "APPS2021", "MAIN");
            FundingAgreementTemplate template2122 =
                documentConfigurationSource.GetFundingAgreementTemplateNamesForAllocation("APPS", "APPS2122", "MAIN");

            // assert
            Assert.AreEqual("A2_MAIN{0}", template1920.TemplateName, "Unexpected template name returned for APPS1920");
            Assert.AreEqual("A2_MAIN{0}", template2021.TemplateName, "Unexpected template name returned for APPS2021");
            Assert.AreEqual("A2_MAIN{0}", template2122.TemplateName, "Unexpected template name returned for APPS2122");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EdskTotalValueCalculator_ShouldSumValuesAcrossFiscalPeriods()
        {
            var allocation = new contractAllocationsContractAllocation
            {
                period = new period { period1 = "1819" },
                fundingStreamPeriodCode = "OTHER",
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                {
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverable = new deliverableType { deliverableCode = 1 },
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { year = 2018, period = 8, plannedValue = 10 },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { year = 2018, period = 4, plannedValue = 20 },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { year = 2019, period = 2, plannedValue = 30 },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { year = 2019, period = 4, plannedValue = 40 },
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod { year = 2019, period = 8, plannedValue = 50 }
                        }
                    }
                }
            };

            decimal total = EdskTotalValueCalculator.GetAllocationTotal(allocation);

            Assert.AreEqual(150m, total);
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(ApplicationException))]
        public void EdskTotalValueCalculator_ShouldThrowWhenStartYearIsInvalid()
        {
            EdskTotalValueCalculator.GetAllocationTotal(new contractAllocationsContractAllocation
            {
                period = new period { period1 = "ABCD" }
            });
        }

        [TestMethod, TestCategory("UnitTest"), ExpectedException(typeof(ApplicationException))]
        public void EdskTotalValueCalculator_ShouldThrowWhenEndYearIsInvalid()
        {
            EdskTotalValueCalculator.GetAllocationTotal(new contractAllocationsContractAllocation
            {
                period = new period { period1 = "18AB" }
            });
        }

        private contract GetRichContract(int deliverableCode = 2)
        {
            return new contract
            {
                fundingType = new fundingType {fundingTypeCode = "ESF"},
                contractNumber = "MASTER-001",
                contracts = new List<contractType>
                {
                    new contractType
                    {
                        contractAllocations = new List<contractAllocationsContractAllocation>
                        {
                            new contractAllocationsContractAllocation
                            {
                                contractAllocationNumber = "ALLOCATION-001",
                                startDate = new DateTime(2015, 08, 01),
                                endDate = new DateTime(2016, 07, 31),
                                description = "Allocation One",
                                AgreementNumber = "",
                                SpecificationTitle = "",
                                tenderSpecificationReference = "",
                                LEPName = "",
                                lotReference = "",
                                fundingStreamPeriodCode = "ESF1420",
                                fundingStream = new fundingStream
                                {
                                    fundingStreamCode = "ESF 201420"
                                },
                                period = new period
                                {
                                    periodType = new periodTypeType {periodTypeCode = periodTypeCodeType.ESF},
                                    period1 = "1420"
                                },
                                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                                {
                                    new contractDeliverablesTypeContractDeliverable
                                    {
                                        deliverableDescription = "Use This One",
                                        deliverable = new deliverableType
                                        {
                                            deliverableCode = deliverableCode
                                        },
                                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                        {
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 8,
                                                year = 2015,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.AY
                                                },
                                                plannedValue = 1234
                                            },
                                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                            {
                                                period = 9,
                                                year = 2015,
                                                periodType = new periodTypeType
                                                {
                                                    periodTypeCode = periodTypeCodeType.AY
                                                },
                                                plannedValue = 4321
                                            },
                                        }

                                    }
                                }
                            }
                        },
                        startDate = new DateTime(2015, 08, 01),
                        contractNumber = "CONTRACT-001",
                        contractVersionNumber = 1,
                        contractor = new contractor
                        {
                            ukprn = 12345678,
                            legalName = "Provider Name"
                        }
                    }
                },
                contractor = new contractor
                {
                    ukprn = 12345678,
                    legalName = "Provider Name"
                }
            };
        }

        private contract GetEfaContract()
        {
            var contract = GetRichContract();
            contract.contracts[0].period.period1 = "1718";
            contract.fundingType.fundingTypeCode = "1619FUND";
            contract.contracts[0].fundingType.fundingTypeCode = "1619FUND";
            contract.contracts[0].startDate = new DateTime(2017,8,1);
            contract.contracts[0].contractAllocations = new List<contractAllocationsContractAllocation>
            {
                new contractAllocationsContractAllocation
                {
                    contractAllocationNumber = "ALLOCATION-001",
                    startDate = new DateTime(2017, 08, 01),
                    endDate = new DateTime(2018, 07, 31),
                    description = "Kent County Council",
                    DeliveryOrganisation = "12345678",
                    AgreementNumber = "",
                    SpecificationTitle = "",
                    tenderSpecificationReference = "",
                    LEPName = "",
                    lotReference = "",
                    fundingStreamPeriodCode = "1619LR1718",
                    fundingStream = new fundingStream
                    {
                        fundingStreamCode = "1619LR"
                    },
                    period = new period
                    {
                        periodType = new periodTypeType {periodTypeCode = periodTypeCodeType.AY},
                        period1 = "1718"
                    },
                    contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                    {
                        new contractDeliverablesTypeContractDeliverable
                        {
                            deliverableDescription = "Do not use this one",
                            deliverable = new deliverableType
                            {
                                deliverableCode = 19
                            },
                            contractDeliverablePeriods =
                                new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                                {
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 8,
                                        year = 2017,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.CM
                                        },
                                        plannedValue = 1234
                                    },
                                    new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                    {
                                        period = 9,
                                        year = 2017,
                                        periodType = new periodTypeType
                                        {
                                            periodTypeCode = periodTypeCodeType.CM
                                        },
                                        plannedValue = 4321
                                    },
                                }

                        }
                    }
                }
            };

            return contract;
        }

        private contractType GetContractFromMessageInFile()
        {
            return TestResource.FromJson<DocumentGenerationCommand>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                "Resources.DocGenCommandDeliveryOrg.json").CorporateContract;
        }

        private contract GetEfaContractWithMultipleDeliveryOrgs()
        {
            var contract = GetEfaContract();
            contract.contracts[0].contractAllocations.Add(new contractAllocationsContractAllocation
            {
                contractAllocationNumber = "ALLOCATION-002",
                startDate = new DateTime(2017, 08, 01),
                endDate = new DateTime(2018, 07, 31),
                description = "Other Provider",
                DeliveryOrganisation = "87654321",
                AgreementNumber = "",
                SpecificationTitle = "",
                tenderSpecificationReference = "",
                LEPName = "",
                lotReference = "",
                fundingStreamPeriodCode = "SSF1718",
                fundingStream = new fundingStream
                {
                    fundingStreamCode = "SSF"
                },
                period = new period
                {
                    periodType = new periodTypeType {periodTypeCode = periodTypeCodeType.AY},
                    period1 = "1718"
                },
                contractDeliverables = new List<contractDeliverablesTypeContractDeliverable>
                {
                    new contractDeliverablesTypeContractDeliverable
                    {
                        deliverableDescription = "Do not use this one",
                        deliverable = new deliverableType
                        {
                            deliverableCode = 13
                        },
                        contractDeliverablePeriods =
                            new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                            {
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    period = 8,
                                    year = 2017,
                                    periodType = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCodeType.CM
                                    },
                                    plannedValue = 4321.02m
                                },
                                new contractDeliverablePeriodsTypeContractDeliverablePeriod
                                {
                                    period = 9,
                                    year = 2017,
                                    periodType = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCodeType.CM
                                    },
                                    plannedValue = -1234
                                },
                            }
                    }
                }
            });

            return contract;
        }

        private static void TestIsHeaderRequired<T>(bool value) where T : DocumentPartCreator
        {
            var isHeaderDocumentRequiredPropertyInfo = typeof(T).GetProperty("IsHeaderDocumentRequired");
            Assert.IsNotNull(isHeaderDocumentRequiredPropertyInfo);
            var getIsHeaderDocumentRequired = isHeaderDocumentRequiredPropertyInfo.GetGetMethod();
            Assert.IsNotNull(getIsHeaderDocumentRequired);

            var creator = (T)Activator.CreateInstance(typeof(T), new object[] { null, null, null });
            Assert.AreEqual(getIsHeaderDocumentRequired.Invoke(creator, new object[0]), value);
        }
        
        private static class FspFactory
        {
            public static DataStore.Models.FundingStreamPeriod GetDefaultFsp()
            {
                return new SFA.FCT.DocumentsDomain.DataStore.Models.FundingStreamPeriod(
                    string.Empty,
                    string.Empty,
                    0,
                    false,
                    false,
                    string.Empty,
                    string.Empty,
                    string.Empty,
                    string.Empty);
            }
        }
    }
}
