namespace FctServices
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Collections.Concurrent;
    using Deds;
    using global::DedsSearchService;
    using Deds.Entities;
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "DedsSearchService" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select DedsSearchService.svc or DedsSearchService.svc.cs at the Solution Explorer and start debugging.

    public class DedsSearchService : IDedsSearchService
    {
        private const int DefaultPageSize = 100;
        private const int DefaultPageNumber = 1;

        private static readonly Guid GetSummarisedActualsGuid = Guid.Parse("8fa418c1-0406-4c05-803d-3b0deb8d1e92");
        private static readonly Guid GetClosedCollectionEventsGuid = Guid.Parse("7e5456f7-f9e3-4904-9059-4bfa57908dbe");
        private static readonly Guid GetSummarisedActualsCountGuid = Guid.Parse("03311bdc-a815-4d0f-9fd9-f13984293f0b");
        private static readonly Guid GetFundingClaimCompletedCollectionsGuid = Guid.Parse("21515ad4-7491-4441-9ac2-16c38a1334dc");
        private static readonly Guid GetFundingClaimsThatAreCompletedGuid = Guid.Parse("293f2fa0-2578-4cc5-8c14-1c800fe9016e");
        private static readonly Guid GetFundingClaimsThatAreCompletedCountGuid = Guid.Parse("661e57ca-1838-43cc-8bba-d0b833ae9b6d");

        private readonly IDictionary<Guid, Func<QueryExecution, QueryResults[]>> _queryActions = new ConcurrentDictionary<Guid, Func<QueryExecution, QueryResults[]>>();

        private IReportedActualRepository _reportedActualRepository { get; set; }

        private readonly IFundingClaimRepository _fundingClaimRepository;

        public DedsSearchService(IReportedActualRepository reportedActualRepository, IFundingClaimRepository fundingClaimRepository)
        {
            _queryActions.Add(GetSummarisedActualsGuid, GetActuals);
            _queryActions.Add(GetClosedCollectionEventsGuid, GetClosedCollectionEvents);
            _queryActions.Add(GetSummarisedActualsCountGuid, GetSummarisedActualsCount);
            _queryActions.Add(GetFundingClaimCompletedCollectionsGuid, GetFundingClaimCompletedCollections);
            _queryActions.Add(GetFundingClaimsThatAreCompletedGuid, GetFundingClaimsThatAreCompleted);
            _queryActions.Add(GetFundingClaimsThatAreCompletedCountGuid, GetFundingClaimsThatAreCompletedCount);

            _reportedActualRepository = reportedActualRepository;
            _fundingClaimRepository = fundingClaimRepository;
        }

        public DataSetDescriptor GetDataSet(Guid dataSetId)
        {
            throw new NotImplementedException();
        }

        public DataSetDescriptor GetDataSetByCode(string code)
        {
            throw new NotImplementedException();
        }

        public DataSetVersionDescriptor[] DiscoverDataSetVersions(DiscoverDataSetVersionsCriteria discoverDataSetVersionsCriteria)
        {
            throw new NotImplementedException();
        }

        public QueryDescriptor[] DiscoverQueries(DiscoverQueriesCriteria discoverQueriesCriteria)
        {
            string[] pickListValue = new[] { "CollectionType" };
            FilterDescriptor fdCollectionType = new FilterDescriptor()
            {
                FieldDescription = "Mandatory - Filter by the [CollectionType] column.",
                FieldName = "CollectionType",
                FieldOperator = "Equals",
                FieldType = "string",
                IsRequired = true,
                PickListValues = pickListValue
            };

            FilterDescriptor fdCollectionReturnCode = new FilterDescriptor()
            {
                FieldDescription = "Mandatory - Filter by the [CollectionReturnCode] column.",
                FieldName = "CollectionReturnCode",
                FieldOperator = "Equals",
                FieldType = "string",
                IsRequired = true,
                PickListValues = pickListValue
            };

            FilterDescriptor fdDataCollectionKey = new FilterDescriptor
            {
                FieldDescription = "Mandatory - Filter by the [DataCollectionKey] column",
                FieldName = "dataCollectionKey",
                FieldOperator = "Equals",
                FieldType = "string",
                IsRequired = true
            };

            QueryDescriptor[] queryDescriptors = new QueryDescriptor[]
            {
                new QueryDescriptor
                {
                    Code = "GetClosedCollectionEvents",
                    Description = "Description",
                    Id = GetClosedCollectionEventsGuid,

                    FilterDescriptors = new[] {new FilterDescriptor
                    {
                        FieldDescription = "Mandatory - Filter by the [CollectionType] column.",
                        FieldName = "closedCollectionSince",
                        FieldOperator = "Equals",
                        FieldType = "date",
                        IsRequired = true,
                    }}
                },

                new QueryDescriptor()
                {
                    Code = "GetSummarisedActualsCount",
                    Description = "Description",
                    Id = GetSummarisedActualsCountGuid,
                    FilterDescriptors = new[] { fdCollectionType, fdCollectionReturnCode }
                },

                new QueryDescriptor()
                {
                    Code = "GetSummarisedActuals",
                    Description = "Description",
                    Id = GetSummarisedActualsGuid,
                    FilterDescriptors = new[] { fdCollectionType, fdCollectionReturnCode }
                },

                new QueryDescriptor()
                {
                    Code = "GetFundingClaimCompletedCollections",
                    Description = "Description",
                    Id = GetFundingClaimCompletedCollectionsGuid,
                    FilterDescriptors = new[]
                    {
                        new FilterDescriptor
                        {
                            FieldDescription = "Optional - Funding claims after this date are returned",
                            FieldName = "Since",
                            FieldOperator = "Equals",
                            FieldType = "date",
                            IsRequired = false
                        }
                    }
                },

                new QueryDescriptor()
                {
                    Code = "GetFundingClaimsThatAreCompleted",
                    Description = "Description",
                    Id = GetFundingClaimsThatAreCompletedGuid,
                    FilterDescriptors = new[] { fdDataCollectionKey }
                },

                new QueryDescriptor()
                {
                    Code = "GetFundingClaimsThatAreCompletedCount",
                    Description = "Description",
                    Id = GetFundingClaimsThatAreCompletedCountGuid,
                    FilterDescriptors = new[] { fdDataCollectionKey }
                }
            };

            return queryDescriptors;
        }

        public FileDescriptor[] DiscoverFiles(DiscoverFilesCriteria discoverFilesCriteria)
        {
            throw new NotImplementedException();
        }

        public long DiscoverFilesCount(DiscoverFilesCriteria discoverFilesCriteria)
        {
            throw new NotImplementedException();
        }

        public QueryResults[] ExecuteQuery(Guid queryId, QueryExecution queryExecution)
        {
            QueryResults[] results = null;
            if (_queryActions.ContainsKey(queryId))
            {
                Func<QueryExecution, QueryResults[]> getRequeryResults = _queryActions[queryId];
                results = getRequeryResults(queryExecution);
            }
            else
            {
                throw new ArgumentException(string.Format("The queryId :{0} is not valid", queryId));
            }

            return results;

            /* string[] fieldNames = new[]
            {
                "CollectionReturnCode",
                "OrganisationId",
                "PeriodTypeCode",
                "Period",
                "FundingStreamPeriodCode",
                "CollectionType",
                "ContractAllocationNumber",
                "UoPCode",
                "DeliverableCode",
                "ActualVolume",
                "ActualValue"
            };

            string[][] results = {
                    new[] {"EopR1", "10000020", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000021", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000022", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000023", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                    new[] {"EopR1", "10000024", "CM","201403","24+ALLF1415","24ALLF","","0","3","13928","0.00"},
                };

            return new[] { new QueryResults() { FieldNames = fieldNames,  Results = results} };*/

        }

        public long GetTotalCount(Guid queryId, QueryExecution queryExecution)
        {
            
            throw new NotImplementedException();
        }

        public QueryResults[] ExecuteQueryByCode(Guid dataSetVersionId, string queryCode, QueryExecution queryExecution)
        {
            throw new NotImplementedException();
        }

        public long GetTotalCountByCode(Guid dataSetVersionId, string queryCode, QueryExecution queryExecution)
        {
            throw new NotImplementedException();
        }

        public FileData GetFile(Guid fileId)
        {
            throw new NotImplementedException();
        }

        public DataSetVersionDescriptor GetLatestPublishedDataSetVersion(string dataSetCode)
        {
            return new DataSetVersionDescriptor
            {
                Id = Guid.NewGuid()
            };
        }

        public DataSetVersionDescriptor[] GetPublishedDataSetVersions(string dataSetCode)
        {
            throw new NotImplementedException();
        }

        public QueryResults[] GetActuals(QueryExecution queryExecution)
        {
            ValidatePageParams(queryExecution);
            string collectionType = queryExecution.FilterValues.First(fv => fv.FieldName == "CollectionType").FieldValue;
            string collectionReturnCode = queryExecution.FilterValues.First(fv => fv.FieldName == "CollectionReturnCode").FieldValue;
            var rows = _reportedActualRepository.GetRows(queryExecution.PageNumber.Value, queryExecution.PageSize.Value, collectionType, collectionReturnCode);
            if (rows.Any())
            {
                return EntityTransformer<ReportedActual>.TransformToQueryResults(rows);
            }

            var results = new QueryResults[1];
            results[0] = new QueryResults
            {
                Results = new string[0][]
            };
            return results;
        }

        public QueryResults[] GetClosedCollectionEvents(QueryExecution queryExecution)
        {
            IList<CollectionGroup> collectionGroups = _reportedActualRepository.GetCollectionGroups();
            if (collectionGroups.Any())
            {
                string[][] results = new string[collectionGroups.Count][];
                
                for (int i = 0; i < collectionGroups.Count; i++)
                {
                    results[i] = new[] { collectionGroups[i].CollectionType, collectionGroups[i].CollectionReturnCode, "14/07/2015 11:33:27" };
                }

                return CreateDefaultClosedCollectionEventsForResults(results);
            }
            else
            {
                string[][] results = new string[2][];
                results[0] = new[] { "Epc", "1", "14/07/2015 11:33:27" };
                results[1] = new[] { "Epc", "2", "14/07/2015 11:33:27" };
                return CreateDefaultClosedCollectionEventsForResults(results);
            }
        }

        private QueryResults[] CreateDefaultClosedCollectionEventsForResults(string[][] results)
        {
            
            QueryResults queryResults = new QueryResults
            {
                FieldNames = new[] { "CollectionType", "CollectionReturnCode", "DateTime" },
                Results = results
            };

            QueryResults[] resultsArray = new QueryResults[1];
            resultsArray[0] = queryResults;
            return resultsArray;
        }

        public QueryResults[] GetSummarisedActualsCount(QueryExecution queryExecution)
        {
            string[][] results = new string[1][];
            string collectionType = queryExecution.FilterValues.First(fv => fv.FieldName == "CollectionType").FieldValue;
            string collectionReturnCode = queryExecution.FilterValues.First(fv => fv.FieldName == "CollectionReturnCode").FieldValue;
            results[0] = new[] { _reportedActualRepository.GetTotal(collectionType, collectionReturnCode).ToString() };
            
            QueryResults queryResults = new QueryResults
            {
                FieldNames = new[] { "RowCount" },
                Results = results
            };

            QueryResults[] resultsArray = new QueryResults[1];
            resultsArray[0] = queryResults;
            return resultsArray;
        }

        private void ValidatePageParams(QueryExecution queryExecution)
        {
            if (!queryExecution.PageNumber.HasValue || !queryExecution.PageSize.HasValue)
            {
                throw new ArgumentException("Page Params not set");
            }
        }

        private QueryResults[] GetFundingClaimCompletedCollections(QueryExecution queryExecution)
        {
            IEnumerable<string> completedClaimTypePeriods = _fundingClaimRepository.GetCompletedClaimTypePeriods();

            List<string> results = new List<string>();
            foreach(string claimTypePeriod in completedClaimTypePeriods)
            {
                results.Add(CreateCollectionDetailsXmlBlock(claimTypePeriod));
            };

            QueryResults queryResults = new QueryResults
            {
                FieldNames = new[] { "XML" },
                Results = new string[1][]
            };

            queryResults.Results[0] = results.ToArray();

            return new QueryResults[] { queryResults };
        }

        private QueryResults[] GetFundingClaimsThatAreCompleted(QueryExecution queryExecution)
        {
            string dataCollectionKey = queryExecution.FilterValues.Single(fv => fv.FieldName == "dataCollectionKey").FieldValue;
            string[] dataCollectionKeySplit = dataCollectionKey.Split('-');
            string period = dataCollectionKeySplit[0];
            string claimType = dataCollectionKeySplit[1];

            int pageSize = queryExecution.PageSize.HasValue ? queryExecution.PageSize.Value : DefaultPageSize;
            int pageNumber = queryExecution.PageNumber.HasValue ? queryExecution.PageNumber.Value : DefaultPageNumber;

            IEnumerable<FundingClaim> rows = _fundingClaimRepository.GetRows(pageNumber, pageSize, period, claimType);

            var results = new QueryResults[1];

            if (rows.Any())
            {
                results[0] = new QueryResults
                {
                    FieldNames = new[] { "XML" },
                    Results =
                        CreateCompletedFundingClaimResultsFromRows(rows, dataCollectionKey)
                        .Select(s => new[] { s })
                        .ToArray()
                };
            }
            else
            {
                results[0] = new QueryResults
                {
                    FieldNames = new[] { "XML" },
                    Results = new string[0][]
                };
            }

            return results;
        }

        private QueryResults[] GetFundingClaimsThatAreCompletedCount(QueryExecution queryExecution)
        {
            string[] dataCollectionKey = queryExecution.FilterValues.Single(fv => fv.FieldName == "dataCollectionKey").FieldValue.Split('-');
            string period = dataCollectionKey[0];
            string claimType = dataCollectionKey[1];

            int count = _fundingClaimRepository.GetTotal(period, claimType);

            QueryResults queryResults = new QueryResults
            {
                FieldNames = new[] { "Count" },
                Results = new[]
                { 
                    new[]
                    {
                        $"<Count>{count}</Count>"
                    }
                }
            };

            return new[] { queryResults };
        }

        private static string CreateCollectionDetailsXmlBlock(string dataCollectionKey)
        {
            string collectionDetailsFormat =
                "<CollectionDetails><DataCollectionKey>{0}</DataCollectionKey><SubmissionOpenDate></SubmissionOpenDate><SubmissionCloseDate></SubmissionCloseDate><SignatureCloseDate></SignatureCloseDate><RequiresSignature></RequiresSignature></CollectionDetails>";

            return string.Format(collectionDetailsFormat, dataCollectionKey);
        }

        private static string[] CreateCompletedFundingClaimResultsFromRows(IEnumerable<FundingClaim> rows, string dataCollectionKey)
        {
            List<string> results = new List<string>();

            results.Add(CreateCollectionDetailsXmlBlock(dataCollectionKey));

            foreach(var row in rows)
            {
                results.Add(row.FundingClaimXml);
            }

            return results.ToArray();
        }
    }
}
