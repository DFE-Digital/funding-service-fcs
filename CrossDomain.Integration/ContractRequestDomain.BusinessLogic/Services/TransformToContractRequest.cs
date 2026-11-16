namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using Interfaces;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;
    using ExcelUpload = CrossDomain.Integration.Entities.ExcelUpload;

    public class TransformToContractRequest : ITransformToContractRequest
    {
        public const string DeliveryOrgColumnName = "DeliveryOrganisation";
        private List<contractRequestType> _contractRequestList;
        private List<contractType> _subContractsList;
        private List<contractAllocation> _allocationsList;

        public contractRequestType[] Transform(dataLoadResults dataLoadResults)
        {
            _contractRequestList = new List<contractRequestType>();
            _subContractsList = new List<contractType>();
            _allocationsList = new List<contractAllocation>();

            TranslateContractSheet(dataLoadResults);
            TranslateContractAllocationsSheet(dataLoadResults);
            TranslateContractDeliverableSheet(dataLoadResults);
            TranslateErrors(dataLoadResults);
            TranslateFundingConfiguration(dataLoadResults);

            return _contractRequestList.ToArray<contractRequestType>();
        }

        private void TranslateContractSheet(dataLoadResults dataLoad)
        {
            sheetType contractSheet = dataLoad.GetSheet("Contract");
            foreach (rowType row in contractSheet.row)
            {
                contractRequestType contractRequest = null;

                string masterContractNum = row.GetCellValue("MasterContractReferenceNumber");
                int ukprn = row.GetCellInt("UKPRN");

                if (masterContractNum != null)
                {
                    contractRequest = _contractRequestList.FirstOrDefault<contractRequestType>(x => x.contract.contractNumber == masterContractNum);
                }
                
                if (contractRequest == null)
                {
                    contractRequest = TranslateContractRequest(dataLoad, row);
                    _contractRequestList.Add(contractRequest);
                }

                contractType subContract = TranslateSubContract(dataLoad, row);
                contractRequest.contract.contracts.Add(subContract);
                _subContractsList.Add(subContract);
            }
        }

        private void TranslateErrors(dataLoadResults dataLoad)
        {
            if (dataLoad.error != null)
            {
                foreach (errorInfo error in dataLoad.error)
                {
                    Guid errorCorrelation = Guid.Parse(error.correlationId);

                    contractRequestType erroneousContract = _contractRequestList.FirstOrDefault(c => c.DoesContractContainCorrelationId(errorCorrelation).HasValue);
                    if (erroneousContract != null)
                    {
                        if (erroneousContract.errorInfo == null)
                        {
                            erroneousContract.errorInfo = new List<errorInfoType>();
                        }

                        erroneousContract.errorInfo.Add(new errorInfoType()
                            {
                                correlationId = error.correlationId,
                                Value = error.Value,
                                level = erroneousContract.DoesContractContainCorrelationId(errorCorrelation).Value
                            });
                    }
                }
            }
        }

        private void TranslateFundingConfiguration(dataLoadResults dataLoad)
        {
            if (dataLoad.ReferenceData != null &&
                dataLoad.ReferenceData.FundingConfiguration != null &&
                dataLoad.ReferenceData.FundingConfiguration.FundingConfigurationList != null)
            {
                List<ContractRequest.FundingConfigurationDataType> fundingConfiguration = new List<ContractRequest.FundingConfigurationDataType>();

                foreach (ExcelUpload.FundingConfigurationDataType fc in dataLoad.ReferenceData.FundingConfiguration.FundingConfigurationList)
                {
                    fundingConfiguration.Add(new ContractRequest.FundingConfigurationDataType()
                    {
                        FundingPeriodEndDate = fc.FundingPeriodEndDate,
                        FundingPeriodStartDate = fc.FundingPeriodStartDate,
                        FundingStreamCode = fc.FundingStreamCode,
                        FundingStreamCodeId = fc.FundingStreamCodeId,
                        FundingStreamId = fc.FundingStreamId,
                        FundingStreamName = fc.FundingStreamName,
                        FundingStreamPeriodCode = fc.FundingStreamPeriodCode,
                        FundingTypeCode = fc.FundingTypeCode,
                        Period = fc.Period,
                        PeriodTypeCode = fc.PeriodTypeCode,
                        PeriodTypeName = fc.PeriodTypeName
                    });
                }

                foreach (contractRequestType c in _contractRequestList)
                {
                    c.FundingConfiguration = fundingConfiguration;
                }
            }
        }

        private void TranslateContractAllocationsSheet(dataLoadResults dataLoad)
        {
            foreach (rowType row in dataLoad.GetSheet("Contract Allocation").row)
            {
                contractType subContract = null;

                string contractNum = row.GetCellValue("ContractNumber");
                int ukprn = row.GetCellInt("UKPRN");

                if (contractNum != null)
                {
                    subContract = _subContractsList.FirstOrDefault<contractType>(s => s.contractNumber == contractNum);
                }
                else
                {
                    subContract = _subContractsList.FirstOrDefault<contractType>(s => s.contractor.ukprn == ukprn);
                }

                if (subContract != null)
                {
                    contractAllocation allocation = TranslateAllocation(dataLoad, row);
                    subContract.contractAllocations.Add(allocation);
                    _allocationsList.Add(allocation);
                }
            }
        }

        private void TranslateContractDeliverableSheet(dataLoadResults dataLoad)
        {
            foreach (rowType row in dataLoad.GetSheet("Deliverable").row)
            {
                contractAllocation allocation = null;

                string allocationNum = row.GetCellValue("ContractAllocationNumber");
                int ukprn = row.GetCellInt("UKPRN");
                string fsc = row.GetCellValue("FundingStreamCode");
                int delCode = row.GetCellInt("DeliverableCode");
                string tenderAwardReference = row.GetCellValue("TenderAwardReference");
                string deliveryOrganisation = row.GetCellValue(DeliveryOrgColumnName);

                if (allocationNum != null)
                {
                    allocation = _allocationsList.FirstOrDefault<contractAllocation>(a => a.contractAllocationNumber == allocationNum);
                }
                else
                {
                    if (!string.IsNullOrEmpty(tenderAwardReference))
                    {
                        allocation = _allocationsList.FirstOrDefault<contractAllocation>(a => a.fundingStreamCode == fsc && a.ukprn == ukprn && a.tenderAwardReference == tenderAwardReference);
                    }
                    else if (!string.IsNullOrEmpty(deliveryOrganisation))
                    {
                        allocation = _allocationsList.FirstOrDefault(a => a.fundingStreamCode == fsc && a.ukprn == ukprn && a.DeliveryOrganisation == deliveryOrganisation);
                    }
                    else
                    {
                        allocation = _allocationsList.FirstOrDefault<contractAllocation>(a => a.fundingStreamCode == fsc && a.ukprn == ukprn);
                    }
                }

                if (allocation != null)
                {
                    contractDeliverable deliverable = allocation.contractDeliverables.FirstOrDefault<contractDeliverable>(d => d.deliverable.fundingStreamCode == fsc && d.deliverable.deliverableCode == delCode);
                    if (deliverable == null)
                    {
                        deliverable = TranslateDeliverable(dataLoad, row);
                        allocation.contractDeliverables.Add(deliverable);
                    }

                    deliverable.contractDeliverablePeriods.Add(TranslateDeliverablePeriod(dataLoad, row));
                }
            }
        }

        private contractRequestType TranslateContractRequest(dataLoadResults dataLoad, rowType row)
        {
            return new contractRequestType()
            {
                correlationInfo =  new correlationInfoType()
                {
                    batchId = dataLoad.batchId,
                    correlationId = Guid.NewGuid().ToString()
                },
                contract = new contractType()
                {
                    correlationId = row.id,
                    fundingTypeCode = dataLoad.GetSheet("Control Sheet").row[0].GetCellValue("FundingTypeCode"),
                    contractNumber = row.GetCellValue("MasterContractReferenceNumber"),
                    contractVersionNumber = 1,
                    hierarchyType = hierarchyType.MASTERCONTRACT,
                    contracts = new List<contractType>(),
                    period = null,
                    startDate = row.GetCellDateTime("ContractStartDate"),
                    endDate = row.GetCellDateTime("ContractEndDate"),
                    CRMIntent = row.GetCellEnum<Intent>("CRMIntent", Intent.New),
                    amendmentType = row.GetCellEnum<amendmentType>("AmendmentType", amendmentType.None),
                        contractor = new Contractor()
                    {
                        ukprn = row.GetCellInt("UKPRN")
                    },
                    description = row.GetCellValue("ContractDescription")
                },
                errorInfo = null
            };
        }

        private contractType TranslateSubContract(dataLoadResults dataLoad, rowType row)
        {
            contractType contract = new contractType()
            {
                correlationId = row.id,
                fundingTypeCode = dataLoad.GetSheet("Control Sheet").row[0].GetCellValue("FundingTypeCode"),
                period = new periodType()
                {
                    periodType1 = new periodTypeType()
                    {
                        periodTypeCode = dataLoad.GetSheet("Control Sheet").row[0].GetCellValue("PeriodTypeCode"),
                        periodTypeName = string.Empty
                    },
                    period = dataLoad.GetSheet("Control Sheet").row[0].GetCellValue("Period"),
                    startDate = DateTime.MinValue,
                    endDate = DateTime.MinValue,
                },
                contractNumber = row.GetCellValue("ContractNumber"),
                contractVersionNumber = 1,
                startDate = row.GetCellDateTime("ContractStartDate"),
                endDate = row.GetCellDateTime("ContractEndDate"),
                CRMIntent = row.GetCellEnum<Intent>("CRMIntent", Intent.New),
                amendmentType = row.GetCellEnum<amendmentType>("AmendmentType", amendmentType.None),
                description = row.GetCellValue("ContractDescription"),
                contractType1 = row.GetCellValue("ContractType"),
                hierarchyType = hierarchyType.CONTRACT,
                contractor = new Contractor()
                {
                    ukprn = row.GetCellInt("UKPRN")
                },
                contractAllocations = new List<contractAllocation>()
            };

            return contract;
        }

        private contractAllocation TranslateAllocation(dataLoadResults dataLoad, rowType row)
        {
            var fundingStreamPeriodCode = string.Empty;
            if (dataLoad.ReferenceData != null)
            {
                var fundingStreamConfiguration = dataLoad.ReferenceData.FundingConfiguration.FundingConfigurationList;
                 fundingStreamPeriodCode = (from f in fundingStreamConfiguration
                    where f.FundingStreamCode == row.GetCellValue("FundingStreamCode")
                    select f.FundingStreamPeriodCode).FirstOrDefault();
            }

            contractAllocation allocation = new contractAllocation()
            {
                correlationId = row.id,
                CRMIntent = row.GetCellEnum<Intent>("CRMIntent", Intent.New),
                period = new periodType()
                {
                    periodType1 = new periodTypeType()
                    {
                        periodTypeCode = dataLoad.GetSheet("Control Sheet").row[0].GetCellValue("PeriodTypeCode"),
                        periodTypeName = string.Empty
                    },
                    period = dataLoad.GetSheet("Control Sheet").row[0].GetCellValue("Period"),
                    startDate = DateTime.MinValue,
                    endDate = DateTime.MinValue,
                },
                contractAllocationNumber = row.GetCellValue("ContractAllocationNumber"),
                startDate = row.GetCellDateTime("StartDate"),
                endDate = row.GetCellDateTime("EndDate"),
                ukprn = row.GetCellInt("UKPRN"),
                fundingStreamCode = row.GetCellValue("FundingStreamCode"),
                LEPName = row.GetCellValue("LEPName"),
                LEPCode = row.GetCellValue("LEPCode"),
                UoPCode = UopCodeTransformer.ZeroPad(row.GetCellValue("UoPCode")),
                tenderSpecificationReference = row.GetCellValue("TenderSpecificationReference"),
                lotReference = row.GetCellValue("LotReference"),
                tenderAwardReference = row.GetCellValue("TenderAwardReference"),
                investmentPriority = row.GetCellValue("InvestmentPriority"),
                description = row.GetCellValue("AllocationDescription"),
                contractDeliverables = new List<contractDeliverable>(),
                fundingStreamPeriodCode = fundingStreamPeriodCode,
                amendmentReason = row.GetCellValue("AmendmentReason"),
                activityDescription = row.GetCellValue("ActivityDescription"),
                agreementNumber = row.GetCellValue("AgreementNumber"),
                specificationTitle = row.GetCellValue("SpecificationTitle"),
                regionType = row.GetCellValue("RegionType"),
                learningRatePremium = row.GetCellValue("LearningRatePremium"),
                DeliveryOrganisation = row.GetCellValue(DeliveryOrgColumnName)
            };

            return allocation;
        }

        private contractDeliverable TranslateDeliverable(dataLoadResults dataLoad, rowType row)
        {
            contractDeliverable deliverable = new contractDeliverable()
            {
                correlationId = row.id,
                CRMIntent = row.GetCellEnum<Intent>("CRMIntent", Intent.New),
                deliverable = new deliverableType()
                {
                    fundingStreamCode = row.GetCellValue("FundingStreamCode"),
                    deliverableCode = row.GetCellInt("DeliverableCode"),
                    deliverableName = row.GetCellValue("DeliverableName")
                },
                deliverableDescription = row.GetCellValue("DeliverableDescription"),
                contractDeliverablePeriods = new List<contractDeliverablePeriodType>(),
                unitCost = row.GetCellNullableDecimal("UnitCost")
            };

            return deliverable;
        }

        private contractDeliverablePeriodType TranslateDeliverablePeriod(dataLoadResults dataLoad, rowType row)
        {
            contractDeliverablePeriodType period = new contractDeliverablePeriodType()
            {
                correlationId = row.id,
                year = row.GetCellInt("Year"),
                period = row.GetCellInt("Period"),
                periodType = new periodTypeType()
                {
                    periodTypeCode = "CM",
                    periodTypeName = "CALENDAR MONTH"
                },
                plannedValue = row.GetCellNullableDecimal("Value"),
                plannedVolume = row.GetCellNullableInt("Volume"),
                unitCost = row.GetCellNullableDecimal("UnitCost")
            };

            return period;
        }
    }
}