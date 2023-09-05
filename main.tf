module "vpc_tf" {
  source = "./modules/networking"
  vpc_tags = {
    Name = "Tag test"
    location = "chittoor"
  }
}





