#import "@preview/modern-cv:0.7.0": *
#import "secrets.typ": phone_number

#show: resume.with(
  author: (
    firstname: "Andrew",
    lastname: "Jackson",
    email: "AndrewJackson2988@gmail.com",
    phone: phone_number,
    github: "AndrewJackson2020",
    linkedin: "andrew-jackson-410aab4b",
    positions: (
      "Software Engineer",
    ),
  ),
  date: datetime.today().display(),
  language: "en",
  colored-headers: true,
  show-footer: false,
)

= Experience

#resume-entry(
  title: "Database Engineer",
  location: "Chicago, IL",
  date: "Jan 2023 - Present",
  description: "Old Mission Capital",
)

#resume-item[
  - Architected firmwide database infrastructure consisting of 15 bare metal database servers
  - Led search for institutional grade open source connection pooler
  - Implemented an instutitutional featureset to open source connection pooling software including GSS authentication, client connection limits, and more
  - Integrated postgres database software with Bazel, the firms build tool enabling more accurate
    testing and faster database development
  - Implemented scheduled backup and retention jobs for all firmwide databases
]

#resume-entry(
  title: "Lead Software Engineer",
  location: "Chicago, IL",
  date: "Aug 2022 - Dec 2023",
  description: "Enfusion",
)
#resume-item[
  - Led the creation of a software development team with the goal of increasing scalability ofthe analytics product line
  - Trained analytics team members in Python programming and software development best practices
  - Architected infrastructure on Google Cloud using Terraform and Docker to ensure reproducible software execution environments with dev/prod parity
  - Enabled cleanup of legacy SQL codebase by introducing Python based application layer delivered via REST API hosted on GCP and securely consumed by AWS based BI application
  - Facilitated fast and consistent database deployments across client environments by writing CLI in Go that leveraged Terraform metaprogramming


]


#resume-entry(
  title: "Software Engineer",
  location: "Downers Grove, IL",
  date: "Oct 2018 - Jul 2022",
  description: "Invesco",
)

#resume-item[
  - Developed R application utilizing the Axioma Portfolio Optimizer API to optimize portfolios and generate reporting and controls around rebalances which was used to manage 5\% of the firms Equity indexed strategy AUM
  - Wrote Python processes to automatically validate index files received from providers to ensure that index holdings comply with the index methodology
  - Designed data warehouse, reporting, and analytics application in Python to integrate index file data, fund position data, as well as market data from the Bloomberg and Factset
 - Built dashboard using Python to provide comprehensive reporting, analytics, and oversight around index rebalances
]

= Open Source

#resume-entry(
  title: "Pgbouncer",
  location: [#github-link("pgbouncer/pgbouncer")],
)

#resume-item[
  - Fixed critical vulnerability that allowed pgbouncer to be succeptable from DDOS attacks
  - Implement GSS Authentication to allow SSO via active directory
  - Implement numerous other features to make pgbouncer a more insitutional capable application
]

#resume-entry(
  title: "Connector X",
  location: github-link("sfu-db/connector-x"),
)

#resume-item[
  - Fix various issues with postgres to polars data type conversions
]

= Skills

#resume-skill-item(
  "Languages",
  (strong("Python"), "C", "Rust", "Go", "R"),
)
#resume-skill-item(
  "Databases",
  (strong("Postgres"), "BigQuery", "Mysql", "SQLite"),
)
#resume-skill-item(
  "Tools",
  ("Git", "Docker", "Podman", "Terraform", "Ansible", "GCP", "Jenkins", "Bazel"),
)
#resume-skill-item(
  "OS",
  (strong("RockyLinux"), strong("NixOS"), "ArchLinux", "Debian", "Windows"),
)

= Education

#resume-entry(
  title: "Northern Illiniois University",
  location: "Dekalb, IL",
  date: "May 2014",
  description: "B.S.",
)
