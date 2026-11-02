BEGIN TRANSACTION

	DELETE FROM MonitoringDeliverables.EsfAllocationData

	;WITH XMLNAMESPACES ('urn:sfa:schemas:contract' AS ns)

	INSERT
		INTO MonitoringDeliverables.EsfAllocationData
	SELECT
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractNumber)[1]', 'nvarchar(128)') ContractNumber,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:contractAllocationNumber)[1]', 'nvarchar(128)') ContractAllocationNumber,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:TenderSpecReference)[1]', 'nvarchar(max)') TenderSpecReference,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:LotReference)[1]', 'nvarchar(max)') LotReference,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:TenderSpecTitle)[1]', 'nvarchar(max)') SpecificationTitle,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:AwardReference)[1]', 'nvarchar(max)') AwardReference,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:ActivityDescription)[1]', 'nvarchar(max)') ActivityDescription,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:InvestmentPriority)[1]', 'nvarchar(max)') InvestmentPriority,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:LEPCode)[1]', 'nvarchar(max)') LEPCode,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:LEPName)[1]', 'nvarchar(max)') LEPName,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:RegionType)[1]', 'nvarchar(max)') RegionType,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:AgreementNumber)[1]', 'nvarchar(max)') AgreementNumber,
		CAST (Feed.AtomFeedItemXml AS XML).value('(/ns:contract/ns:contracts/ns:contract/ns:contractAllocations/ns:contractAllocation/ns:ProcurementAttrs/ns:LearningRatePremium)[1]', 'nvarchar(max)') LearningRatePremium
	FROM
		(
			SELECT
				MAX(BusinessKey) MaxBusinessKey
			FROM
				ContractManagement.AtomFeedItem
			WHERE
				BusinessKey LIKE 'ESIF-%'
				AND	ItemType = 0
			GROUP BY
				SUBSTRING(BusinessKey, 0, CHARINDEX(':', BusinessKey)) -- ContractNo
		) LatestApprovedContract
		INNER JOIN ContractManagement.AtomFeedItem Feed ON Feed.BusinessKey = MaxBusinessKey
	WHERE
		BusinessKey LIKE 'ESIF-%'
		AND	ItemType = 0
		
	SELECT * FROM MonitoringDeliverables.EsfAllocationData ORDER BY ContractNumber

COMMIT TRANSACTION
