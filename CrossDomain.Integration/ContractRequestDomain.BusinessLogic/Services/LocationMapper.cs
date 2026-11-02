namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Interfaces;
    using Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.ExcelUpload;

    public class LocationMapper : ILocationMapper
    {
        public IDictionary<string, ExcelLocation> GenerateExcelLocations(dataLoadResults dataLoadResults)
        {
            ContractBulkUpload bulkUpload = new ContractBulkUpload(dataLoadResults);

            sheetType[] sheetsToProcess = { bulkUpload.ContractSheet, bulkUpload.ContractAllocationSheet, bulkUpload.ContractDeliverableSheet };

            var locations =
                (from sheet in sheetsToProcess
                 from row in sheet.row
                 select new ExcelLocation()
                 {
                     CorrelationId = row.id,
                     ParentId = null,
                     ContractRequestId = null,
                     Row = row.rowNumber,
                     Sheet = sheet.name
                 })
                 .ToDictionary(k => k.CorrelationId, v => v);

            return locations;
        }

        public void UpdateWithStructuralInformation(IDictionary<string, ExcelLocation> locations, contractRequestType contractRequest)
        {
             foreach (contractType contract in contractRequest.contract.contracts)
             {
                 ExcelLocation location = locations.ContainsKey(contract.correlationId) ? locations[contract.correlationId] : null;

                if (location != null)
                {
                    location.ContractRequestId = contractRequest.correlationInfo.correlationId;
                    location.ParentId = null;
                }

                foreach (contractAllocation allocation in contract.contractAllocations)
                {
                    ExcelLocation allocationLocation = locations.ContainsKey(allocation.correlationId) ? locations[allocation.correlationId] : null;

                    if (allocationLocation != null)
                    {
                        allocationLocation.ContractRequestId = contractRequest.correlationInfo.correlationId;
                        allocationLocation.ParentId = contract.correlationId;
                    }

                    foreach (contractDeliverable deliverable in allocation.contractDeliverables)
                    {
                        foreach (contractDeliverablePeriodType period in deliverable.contractDeliverablePeriods)
                        {
                            ExcelLocation periodLocation = locations.ContainsKey(period.correlationId) ? locations[period.correlationId] : null;

                            if (periodLocation != null)
                            {
                                periodLocation.ContractRequestId = contractRequest.correlationInfo.correlationId;
                                periodLocation.ParentId = allocation.correlationId;
                            }
                        }
                    }
                }
            }
        }
    }
}
