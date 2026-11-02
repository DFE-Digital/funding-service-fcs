  select distinct(c.ContractNumber), year(atom.CreatedDate) as year 
 from
 [ContractManagement].[ApprovedContract] c,
 [ContractManagement].[ApprovedContractAllocation] a,
 [ContractManagement].[AtomFeedItem] atom
 where c.ApprovedContractId = a.ApprovedContractId
 and a.FundingStreamPeriodCode in @fspCodes
 and atom.BusinessKey like concat(c.ContractNumber, '%')
 and atom.ItemType in @closedAtomItemTypes
 and year(atom.CreatedDate) <= @lastYear