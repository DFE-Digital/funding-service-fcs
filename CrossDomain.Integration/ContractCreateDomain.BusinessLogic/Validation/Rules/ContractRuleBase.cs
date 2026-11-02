//namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
//{
//    using System;
//    using System.Collections.Generic;
//    using System.Linq;
//    using CrossDomain.Integration.Entities.ContractRequest;

//    public abstract class ContractRuleBase //// : IRule<contractRequestType>
//    {
//        protected readonly List<errorInfoType> LocalErrors = new List<errorInfoType>();

//        protected abstract string ErrorMsg { get; }

//        protected abstract Func<contractType, bool> EvalFunc { get; }

//        public bool Validate(contractRequestType contract)
//        {
//            var masterContract = contract.contract;

//            // check master
//            CheckContract(masterContract, errorInfoTypeLevel.MasterContract);

//            // check contracts
//            masterContract.contracts.ForEach(c => CheckContract(c, errorInfoTypeLevel.Contract));

//            ContractErrorHelper.AddErrorsToContract(contract, LocalErrors);
//            return !LocalErrors.Any();
//        }

//        private void CheckContract(contractType contract, errorInfoTypeLevel level)
//        {
//            if (EvalFunc(contract))
//            {
//                ContractErrorHelper.AddErrorMsgToErrorList(
//                    LocalErrors,
//                    contract.correlationId,
//                    level,
//                    ErrorMsg);
//            }
//        }
//    }
//}