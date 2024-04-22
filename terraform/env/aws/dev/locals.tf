locals {
  env = basename(abspath(path.module))
  deploy_options = {
    eks = [
      #"karpenter_prereqs",
    ]
  }
}