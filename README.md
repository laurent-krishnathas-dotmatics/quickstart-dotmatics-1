# quickstart-dotmatics


aws s3 sync s3://artifacts-devops-dotmatics-eu-west-1/nas/browser/    ./ --dryrun --exclude "chem*.zip" --include "*.pdf" --include "*.zip"