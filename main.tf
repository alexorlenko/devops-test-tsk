resource "aws_eks_cluster" "eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.eks_public_subnet_1.id,
      aws_subnet.eks_public_subnet_2.id
    ]
  }
  depends_on = [aws_iam_role_policy_attachment.eks_role_policy]
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "my-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = [
    aws_subnet.eks_public_subnet_1.id,
    aws_subnet.eks_public_subnet_2.id
  ]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.micro"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_role_policy,
    aws_iam_role_policy_attachment.eks_node_role_policy_CNI,
    aws_iam_role_policy_attachment.eks_node_role_policy_AmazonEC2ContainerRegistryReadOnly
  ]
}
