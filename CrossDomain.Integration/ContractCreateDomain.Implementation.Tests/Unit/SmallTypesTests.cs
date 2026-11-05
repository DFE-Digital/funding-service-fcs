namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Exceptions;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    internal static class ThrowsHelper
    {
        public static void Throws<T>(Action action) where T : Exception
        {
            try
            {
                action();
            }
            catch (T)
            {
                return;
            }

            Assert.Fail("Expected exception " + typeof(T).Name);
        }
    }

    [TestClass]
    public class PeriodKeyTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PeriodKey_ShouldThrowWhenPeriodNameIsMissing()
        {
            ThrowsHelper.Throws<ArgumentException>(() => new PeriodKey(null, periodTypeCodeType.AY));
            ThrowsHelper.Throws<ArgumentException>(() => new PeriodKey(string.Empty, periodTypeCodeType.AY));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PeriodKey_ShouldExposeValuesItWasCreatedWith()
        {
            var key = new PeriodKey("1516", periodTypeCodeType.AY);

            Assert.AreEqual("1516", key.PeriodName);
            Assert.AreEqual(periodTypeCodeType.AY, key.PeriodTypeCodeType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PeriodKey_EqualsAndHashCode_ShouldMatchOnNameAndType()
        {
            var key = new PeriodKey("1516", periodTypeCodeType.AY);
            var same = new PeriodKey("1516", periodTypeCodeType.AY);
            var differentName = new PeriodKey("1617", periodTypeCodeType.AY);
            var differentType = new PeriodKey("1516", periodTypeCodeType.CY);

            Assert.IsTrue(key.Equals(same));
            Assert.AreEqual(key.GetHashCode(), same.GetHashCode());
            Assert.IsFalse(key.Equals(differentName));
            Assert.IsFalse(key.Equals(differentType));
            Assert.IsFalse(key.Equals(null));
            Assert.IsFalse(key.Equals("1516"));
        }
    }

    [TestClass]
    public class ContractIdentityTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractIdentity_ShouldExposeValuesAndFormatToString()
        {
            var identity = new ContractIdentity("12345", 2, 3);

            Assert.AreEqual("12345", identity.ContractNumber);
            Assert.AreEqual(2, identity.Version);
            Assert.AreEqual(3, identity.SubVersion);
            Assert.AreEqual("ContractNumber: 12345, Version: 2, SubVersion: 3", identity.ToString());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractIdentity_EqualsAndHashCode_ShouldCompareAllParts()
        {
            var identity = new ContractIdentity("12345", 2, 3);

            Assert.IsTrue(identity.Equals(new ContractIdentity("12345", 2, 3)));
            Assert.AreEqual(identity.GetHashCode(), new ContractIdentity("12345", 2, 3).GetHashCode());
            Assert.IsFalse(identity.Equals(new ContractIdentity("99999", 2, 3)));
            Assert.IsFalse(identity.Equals(new ContractIdentity("12345", 1, 3)));
            Assert.IsFalse(identity.Equals(new ContractIdentity("12345", 2, 1)));
            Assert.IsFalse(identity.Equals("12345"));
            Assert.IsFalse(identity.Equals(null));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractIdentity_ShouldConvertImplicitlyFromCrmContract()
        {
            var crmContract = new sfa_contract { sfa_number = "12345", sfa_Version = 4, sfa_SubVersion = 1 };

            ContractIdentity identity = crmContract;

            Assert.AreEqual(new ContractIdentity("12345", 4, 1), identity);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractIdentity_ShouldThrowWhenCrmContractHasNoVersionOrSubVersion()
        {
            ThrowsHelper.Throws<ArgumentException>(() =>
            {
                ContractIdentity identity = new sfa_contract { sfa_number = "12345", sfa_Version = 1 };
            });
            ThrowsHelper.Throws<ArgumentException>(() =>
            {
                ContractIdentity identity = new sfa_contract { sfa_number = "12345", sfa_SubVersion = 1 };
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractIdentity_ShouldConvertImplicitlyFromMasterContractUsingItsChild()
        {
            var master = new ExtendedContractType
            {
                contractNumber = "MASTER",
                contracts = new List<ExtendedContractType>
                {
                    new ExtendedContractType { contractNumber = "CHILD", contractVersionNumber = 3, contractSubVersionNumber = 2 }
                }
            };

            ContractIdentity identity = master;

            Assert.AreEqual(new ContractIdentity("CHILD", 3, 2), identity);
        }
    }

    [TestClass]
    public class ColumnValueTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ColumnValue_GetColumnNameWithAlias_ShouldPrefixAliasWhenSet()
        {
            Assert.AreEqual("a.sfa_number", new ColumnValue { Column = "sfa_number", Alias = "a" }.GetColumnNameWithAlias());
            Assert.AreEqual("sfa_number", new ColumnValue { Column = "sfa_number" }.GetColumnNameWithAlias());
            Assert.AreEqual("sfa_number", new ColumnValue { Column = "sfa_number", Alias = string.Empty }.GetColumnNameWithAlias());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ColumnValue_EqualsAndHashCode_ShouldCompareColumnAndValue()
        {
            var columnValue = new ColumnValue { Column = "sfa_number", Value = "123" };
            var same = new ColumnValue { Column = "sfa_number", Value = "123", Table = "other" };

            Assert.IsTrue(columnValue.Equals(same));
            Assert.AreEqual(columnValue.GetHashCode(), same.GetHashCode());
            Assert.IsFalse(columnValue.Equals(new ColumnValue { Column = "sfa_number", Value = "456" }));
            Assert.IsFalse(columnValue.Equals(new ColumnValue { Column = "sfa_other", Value = "123" }));
            Assert.IsFalse(columnValue.Equals("123"));
        }
    }

    [TestClass]
    public class PresenceCheckItemTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PresenceCheckItem_ShouldInitialiseWithEntityNameAndColumnValues()
        {
            var columnValues = new List<ColumnValue> { new ColumnValue { Column = "c", Value = 1 } };

            var item = new PresenceCheckItem("entity", columnValues);

            Assert.AreEqual("entity", item.EntityName);
            Assert.AreSame(columnValues, item.ColumnValues);
            Assert.IsNotNull(item.ColumnValuesOneOfThese);
            Assert.AreEqual(0, item.ColumnValuesOneOfThese.Count);
            Assert.IsFalse(item.IsPresent);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PresenceCheckItem_SettingIsPresent_ShouldInvokeSetPresentCallback()
        {
            bool? callbackValue = null;
            var item = new PresenceCheckItem("entity", new List<ColumnValue>())
            {
                SetPresent = present => callbackValue = present
            };

            item.IsPresent = true;

            Assert.IsTrue(item.IsPresent);
            Assert.AreEqual(true, callbackValue);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PresenceCheckItem_SettingIsPresent_ShouldNotFailWithoutCallback()
        {
            var item = new PresenceCheckItem("entity", new List<ColumnValue>());

            item.IsPresent = true;

            Assert.IsTrue(item.IsPresent);
        }
    }

    [TestClass]
    public class ExceptionTypesTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractExceptions_ShouldCarryMessage()
        {
            Assert.AreEqual("dup", new DuplicateContractException("dup").Message);
            Assert.AreEqual("missing", new ContractDoesntExistException("missing").Message);
            Assert.AreEqual("exists", new OrganisationAlreadyExistsException("exists").Message);
            Assert.AreEqual("none", new OrganisationDoesntExistException("none").Message);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExceptions_ShouldBeConstructableWithoutMessage()
        {
            Assert.IsNotNull(new DuplicateContractException());
            Assert.IsNotNull(new ContractDoesntExistException());
            Assert.IsNotNull(new OrganisationAlreadyExistsException());
            Assert.IsNotNull(new OrganisationDoesntExistException());
        }
    }

    [TestClass]
    public class ContractNumberGeneratorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractNumberGenerator_ShouldGenerateSixDigitNumber()
        {
            for (int i = 0; i < 20; i++)
            {
                string number = ContractNumberGenerator.GenerateNumber();

                Assert.AreEqual(6, number.Length);
                Assert.IsTrue(int.TryParse(number, out _));
            }
        }
    }

    [TestClass]
    public class OptionSetValueExtensionsGapTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetText_ShouldReturnNullForNullOptionSet()
        {
            OptionSetValue value = null;

            Assert.IsNull(value.GetText<sfa_contractstatus>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetText_ShouldThrowForUndefinedValue()
        {
            ThrowsHelper.Throws<ArgumentOutOfRangeException>(() => new OptionSetValue(-1).GetText<sfa_contractstatus>());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNewStartSuspendedReasonText_ShouldReturnNullForNullOptionSet()
        {
            OptionSetValue value = null;

            Assert.IsNull(value.GetNewStartSuspendedReasonText());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNewStartSuspendedReasonText_ShouldThrowForUndefinedValue()
        {
            ThrowsHelper.Throws<ArgumentOutOfRangeException>(() => new OptionSetValue(-1).GetNewStartSuspendedReasonText());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNewStartSuspendedReasonText_ShouldReturnReadableText()
        {
            Assert.AreEqual("Removed from RoATP", new OptionSetValue((int)sfa_newstartssuspendedreason.RemovedfromRoATP).GetNewStartSuspendedReasonText());
            Assert.AreEqual("Inadequate Ofsted", new OptionSetValue((int)sfa_newstartssuspendedreason.InadequateOfsted).GetNewStartSuspendedReasonText());
            Assert.AreEqual("Other", new OptionSetValue((int)sfa_newstartssuspendedreason.Other).GetNewStartSuspendedReasonText());
        }
    }
}
