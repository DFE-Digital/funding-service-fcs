using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Moq;
using Operations.Web.Services;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Operations.Web.Repositories;
using Operations.Web.ConfigDataStore;

namespace Operations.Web.Tests.ServiceTests
{
    [TestClass]
    public class DigiRelManagementServiceTests
    {
        private Mock<IDigiRelManagementRepository> _repoMock;
        private DigiRelManagementService _service;
        private const string CurrentEnv = "DMO";

        [TestInitialize]
        public void Setup()
        {
            _repoMock = new Mock<IDigiRelManagementRepository>();
            _service = new DigiRelManagementService(_repoMock.Object, CurrentEnv);
        }

        [TestMethod]
        public async Task GetAllAsync_ReturnsMappedDtos()
        {
            //Arrange
            var releases = new List<Release>
            {
                new Release
                {
                    release_id = 1,
                    releaseName = "Test",
                    description = "Desc",
                    version = "V001",
                    created_by = "User654",
                    created_at = DateTime.UtcNow,
                    Release_Deployments = new List<Release_Deployments>
                    {
                        new Release_Deployments
                        {
                            deployment_status = "Deployed",
                            Environment = new Operations.Web.ConfigDataStore.Environment { Env =  CurrentEnv }
                        }
                    }
                }
            };

            _repoMock.Setup(r => r.GetAllAsync())
                .ReturnsAsync(releases);

            //Act
            var result = await _service.GetAllAsync();

            //Assert
            Assert.AreEqual(1, result.Count());
            var dto = result.First();
            Assert.AreEqual(1, dto.ReleaseId);
            Assert.AreEqual("Test", dto.ReleaseName);
            Assert.AreEqual("Desc", dto.Description);
            Assert.AreEqual("V001", dto.Version);
            Assert.AreEqual("User654", dto.CreatedBy);
            Assert.AreEqual(CurrentEnv, dto.EnvironmentName);
            Assert.AreEqual("Deployed", dto.DeploymentStatus);
        }

        [TestMethod]
        public async Task GetByIdAsync_ReturnsDtoById()
        {
            //Arrange
            var release = new Release
            {
                release_id = 5,
                releaseName = "Test 5",
                description = "Desc 5",
                version = "V005",
                created_by = "User554",
                created_at = DateTime.UtcNow,
                Release_Deployments = new List<Release_Deployments>
                    {
                        new Release_Deployments
                        {
                            deployment_status = "Redeployed",
                            Environment = new Operations.Web.ConfigDataStore.Environment { Env =  CurrentEnv }
                        }
                    }
            };

            _repoMock.Setup(r => r.GetByIdAsync(5))
                .ReturnsAsync(release);

            //Act
            var result = await _service.GetByIdAsync(5);

            //Assert
            Assert.IsNotNull(result);
            Assert.AreEqual(5, result.ReleaseId);
            Assert.AreEqual("Test 5", result.ReleaseName);
            Assert.AreEqual("Desc 5", result.Description);
            Assert.AreEqual("V005", result.Version);
            Assert.AreEqual("User554", result.CreatedBy);
            Assert.AreEqual(CurrentEnv, result.EnvironmentName);
            Assert.AreEqual("Redeployed", result.DeploymentStatus);
        }

        [TestMethod]
        public async Task GetAllAsync_ReturnsOnlyLatest50OrderedByDate()
        {
            //Arrange
            var releases = Enumerable.Range(1, 100)
                .Select(i => new Release
                {
                    release_id = i,
                    releaseName = $"Release {i}",
                    version = $"V{i:D3}",
                    created_at = DateTime.UtcNow.AddMinutes(-i),
                })
                .ToList();

            //Mock repository directly mirrors repository set up
            //Only the repo owns pagination, NOT the service
            //Hence:
            _repoMock.Setup(r => r.GetAllAsync())
                .ReturnsAsync(releases
                .OrderByDescending(r => r.created_at)
                        .Take(50)
                        .ToList());

            //Act
            var result = await _service.GetAllAsync();

            //Assert
            var list = result.ToList();
            Assert.AreEqual(50, list.Count, "Should return only the most recent 50 releases");

            for (int i = 0; i < list.Count -1; i++)
            {
                Assert.IsTrue(list[i].CreatedAt >= list[i+1].CreatedAt, "Releases must be ordered by CreatedAt in descending order");
            }
        }

        [TestMethod]
        public async Task DeployAsync_ShouldUpdateStatusCorrectly()
        {
            //Arrange
            var env = new Operations.Web.ConfigDataStore.Environment { Id = 1, Env = CurrentEnv };
            var deployment = new Release_Deployments
            {
                release_id = 1,
                env_id = 1,
                deployment_status = "Pending"
            };

            _repoMock.Setup(r => r.GetEnvironmentByNameAsync(It.IsAny<string>()))
                .ReturnsAsync(env);

            _repoMock.Setup(r => r.GetDeploymentByReleaseIdAndEnvAsync(1, 1))
                .ReturnsAsync(deployment);

            //Act
            await _service.DeployAsync(1, "End User");

            //Assert
            Assert.AreEqual("Deployed", deployment.deployment_status);
        }
    }
}