namespace Operations.Worker.Tests
{
    using System.Collections.Generic;
    using Extensions;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public class StringExtensionTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void StringExtensions_ShouldCleanOddCharsFromJson()
        {
            var inputAndResultList = new List<(string json, string expectedJson)>
            {
                ("{\"UkprnBatch\":[1000001,1000002,7600,7601,7602,7603,7604,12345678],\"ShouldIssueCrmNotifications\":tru�\u0002e}",
                    "{\"UkprnBatch\":[1000001,1000002,7600,7601,7602,7603,7604,12345678],\"ShouldIssueCrmNotifications\":true}"),
                ("@\fbase64Binary\b3http://schemas.microsoft.com/2003/10/Serialization/�'﻿{\"ShouldIssueCrmNotifications\":true}",
                    "{\"ShouldIssueCrmNotifications\":true}"),
                ("{\"ContractNumber\":\"XX=LatestVersionTest\",\"MasterContractNumber\":\"XX-Master\"�\u0001}",
                    "{\"ContractNumber\":\"XX=LatestVersionTest\",\"MasterContractNumber\":\"XX-Master\"}"),
            };

            inputAndResultList.ForEach(i =>
            {
                // act
                var cleanedString = i.json.CleanOddCharsFromJson();
                // assert
                cleanedString.Should().Be(i.expectedJson);
            });
        }
    }
}
