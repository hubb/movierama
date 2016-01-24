module GlobalIdFriendlyFinder
  def find(args)
    if args.is_a?(Hash)
      super(args)
    else
      self[args[0]]
    end
  end
end
