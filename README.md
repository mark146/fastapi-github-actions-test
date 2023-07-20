## Fastapi, Docker-compose, GitHub Actions를 사용한 지속적 통합/지속적 배포(CI/CD) 테스트
- 이 리포지토리에는 develop 브랜치가 변경될 때 Docker 이미지를 자동으로 빌드, 푸시 및 배포하는 GitHub Actions 워크플로가 포함되어 있습니다.


## 워크플로 개요
워크플로우는 build-and-push와 deploy의 두 가지 작업으로 나뉩니다.

1. **build-and-push**: 이 작업은 최신 코드를 확인하고 Docker 이미지를 빌드한 다음 Docker 리포지토리에 푸시합니다. develop 브랜치에 대한 푸시 또는 풀 요청이 있을 때마다 트리거됩니다. 
2. **deploy**: 이 작업은 Docker 이미지를 EC2 인스턴스에 배포합니다. build-and-push 작업이 성공적으로 완료된 후에 실행됩니다. 

 
## 워크플로 단계

### 빌드 및 푸시 작업 
1. **리포지토리 확인**: 리포지토리에서 최신 코드를 확인합니다. 
2. **Docker Hub에 로그인**: 제공된 사용자 이름과 액세스 토큰을 사용하여 Docker Hub에 로그인합니다. 
3. **Docker 이미지 빌드 및 푸시**: 체크아웃된 코드에서 Docker 이미지를 빌드하고 DOCKER_REPO에 정의된 Docker 리포지토리로 푸시합니다. 

### 배포 작업
1. **리포지토리 확인**: 리포지토리에서 최신 코드를 확인합니다.

2. **EC2 Docker Deploy**: SSH를 사용하여 EC2 인스턴스에 연결하고 다음 작업을 수행합니다.
   - git-action-test/ 디렉토리로 이동합니다.
   - 최신 Docker 이미지를 사용하려면 docker-compose.yaml 파일을 업데이트하십시오.
   - 실행 중인 Docker Compose 서비스를 중지합니다.
   - Docker 리포지토리에서 최신 Docker 이미지를 가져옵니다.
   - 분리 모드에서 Docker Compose 서비스를 시작합니다.

## 환경 변수
- 워크플로는 워크플로 파일의 'env' 섹션에 정의되고 GitHub 리포지토리에 비밀로 저장되는 여러 환경 변수를 사용합니다.

  - **DOCKER_HUB_USERNAME**: Docker 허브 사용자 이름입니다.
  - **DOCKER_HUB_ACCESS_TOKEN**: Docker Hub 액세스 토큰입니다.
  - **DOCKER_REPO**: Docker 이미지가 푸시되는 Docker 저장소입니다.
  - **AWS_HOST**: EC2 인스턴스의 IP 주소 또는 호스트 이름.
  - **AWS_SSH_KEY**: EC2 인스턴스에 접속하기 위한 SSH 키.
  - **AWS_USER**: EC2 인스턴스에 연결하기 위한 사용자 이름입니다.


- 워크플로를 실행하기 전에 리포지토리 설정에서 이러한 비밀을 설정했는지 확인하십시오.

## 도커 작성
- git-action-test/ 디렉터리의 docker-compose.yaml 파일은 Docker Compose 서비스를 실행하는 데 사용됩니다. 최신 Docker 이미지를 사용하도록 deploy 작업 중에 업데이트됩니다. 그러면 Docker Compose 서비스가 중지, 업데이트 및 다시 시작됩니다.