# AWS 3-Tier 및 Data Pipeline 구축

## 🖥️ 프로젝트 소개
- 웹 쇼핑몰 3-Tier 인프라 설계 및 구축
- CI/CD  파이프라인, 모니터링, 백업 환경 구축
- 데이터 분석 파이프라인 설계 및 구축
### 📆 일정
- 2024.04.22 ~ 2024.06.25 (9주)
- 개인 및 팀 프로젝트
  
### ✏️ 담당 업무
- 고객 요구사항 분석 및 고객 시나리오 구성
- 아키텍처 설계
- 3-Tier 구축 (Web, WAS, DB 연동)
- CI/CD 파이프라인 구축
- 자동화된 데이터베이스 백업 환경 구축
- 서버 지표 모니터링 환경 구축 및 Slack 알람 연동
- 인사이트 구성 및 분석된 데이터 시각화 환경 구축

## 🖥️ 프로젝트 결과
- 아키텍처
<img src="https://github.com/estrellaSia/AWS_3Tier_Infra_Data_Pipeline/assets/127510529/699e000b-a871-4a8f-94d5-20c8d8420475">

- 3Tier 구축
  - Web, WAS, DB 연동 후 도메인과 HTTPS 연결로 서버 접속
<img src="https://github.com/estrellaSia/AWS_3Tier_Infra_Data_Pipeline/assets/127510529/d6c88abc-e334-4eee-9011-6bf6f37bba8c">

- CI/CD 파이프라인 구축
  - 기존의 Web, WAS 서버에 롤링 업데이트를 통해 서버 배포
![Untitled (17)](https://github.com/estrellaSia/AWS_3Tier_Infra_Data_Pipeline/assets/127510529/e571acf0-64e3-4417-ac1c-b26c901c77b9)

- DB 백업
  - RDS 스냅샷 생성 자동화
![Untitled (23)](https://github.com/estrellaSia/AWS_3Tier_Infra_Data_Pipeline/assets/127510529/c7a78c05-b1a1-4f90-8076-972e271c825e)
  - 백업 복원
![Untitled (19)](https://github.com/estrellaSia/AWS_3Tier_Infra_Data_Pipeline/assets/127510529/9f9e1695-e799-4d45-a090-8971e9a61fd3)

- 모니터링
  - Web, WAS 서버의 CPU 사용량 모니터링
  - CPU 사용량 75% 이상 시 경보 생성 및 Slack 알람 전송 
![Untitled (21)](https://github.com/estrellaSia/AWS_3Tier_Infra_Data_Pipeline/assets/127510529/f192da5a-f5b1-415d-8fb8-03f4118a1d7e)

- 데이터 시각화
  - Amazon QuidckSight를 통해 분석된 데이터 시각화
![Untitled (22)](https://github.com/estrellaSia/AWS_3Tier_Infra_Data_Pipeline/assets/127510529/346b8dd0-deef-4b7b-bfdf-4790bf9e8d70)
