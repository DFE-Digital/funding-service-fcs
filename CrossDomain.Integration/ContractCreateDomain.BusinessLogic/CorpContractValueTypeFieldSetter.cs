namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System;
    using System.Linq;
    using System.Reflection;
    using CrossDomain.Integration.Entities.CorporateContract;

    public static class CorpContractValueTypeFieldSetter
    {
        public static void SetSpecifiedValuesToTrue(Contract corpContract)
        {
            SetSpecifiedValuesToTrueWhenRelatedValueSet(corpContract);
            SetSpecifiedValuesToTrueWhenRelatedValueSet(corpContract.contractor);
            foreach (var subContract in corpContract.contracts)
            {
                SetSpecifiedValuesToTrueWhenRelatedValueSet(subContract);
                SetSpecifiedValuesToTrueWhenRelatedValueSet(subContract.contractor);
                foreach (var contractAllocation in subContract.contractAllocations)
                {
                    SetSpecifiedValuesToTrueWhenRelatedValueSet(contractAllocation);
                    foreach (var deliverable in contractAllocation.contractDeliverables)
                    {
                        SetSpecifiedValuesToTrueWhenRelatedValueSet(deliverable);
                        foreach (var deliverablePeriod in deliverable.contractDeliverablePeriods)
                        {
                            SetSpecifiedValuesToTrueWhenRelatedValueSet(deliverablePeriod);
                        }
                    }
                }
            }
        }

        private static void SetSpecifiedValuesToTrueWhenRelatedValueSet<T>(T obj)
        {
            var props = typeof(T).GetProperties();
            foreach (var prop in props)
            {
                if (prop.PropertyType.IsValueType)
                {
                    object value = prop.GetValue(obj, null);
                    object defaultValue = GetDefaultValue(prop.PropertyType);
                    if (!value.Equals(defaultValue))
                    {
                        SetSecifiedPropertyToTrue(obj, prop);
                    }
                }
            }
        }

        private static object GetDefaultValue(Type type)
        {
            return Activator.CreateInstance(type);
        }

        private static void SetSecifiedPropertyToTrue<T>(T obj, PropertyInfo valuePropertyInfo)
        {
            const string specified = "Specified";
            var specifiedProps = typeof(T).GetProperties().Where(p => (p.Name == valuePropertyInfo.Name + specified) && p.PropertyType == typeof(bool));
            foreach (var specifiedProp in specifiedProps)
            {
                specifiedProp.SetValue(obj, true);
            }
        }
    }
}
