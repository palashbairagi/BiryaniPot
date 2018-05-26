//
//  OrderViewController.m
//  BiryaniPot
//
//  Created by Palash Bairagi on 12/22/17.
//  Copyright © 2017 Palash Bairagi. All rights reserved.
//

#import "OrderViewController.h"
#import "QueueTableViewCell.h"
#import "PreparingTableViewCell.h"
#import "OutForDeliveryTableViewCell.h"
#import "ReadyToPickUpTableViewCell.h"
#import "CompleteTableViewCell.h"
#import "OrderDetailViewController.h"
#import "SearchTableViewCell.h"
#import "Order.h"
#import "Constants.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    @try
    {
        [_waitView setHidden:FALSE];
        [_activityIndicator startAnimating];
        
        [super viewDidAppear:animated];
        
        [self initComponents];
        [self loadData];
        
        [_activityIndicator stopAnimating];
        [_waitView setHidden:TRUE];
    }@catch(NSException *e)
    {
        NSLog(@"%@ %@", e.name, e.reason);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to Process, Please Login again" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [super logout];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.queueTableView)
    {
        return self.queueArray.count;
    }
    else if(tableView == self.preparingTableView)
    {
        return self.preparingArray.count;
    }
    else if (tableView == self.outForDeliveryTableView)
    {
        return self.outForDeliveryArray.count;
    }
    else if (tableView == self.readyToPickupTableView)
    {
        return self.readyToPickUpArray.count;
    }
    else if (tableView == self.completeTableView)
    {
        return self.completeArray.count;
    }
    else
    {
//        if(self.searchArray.count > 3)
//            return 4;
//        else
            return self.searchArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _queueTableView || tableView == _preparingTableView || tableView == _outForDeliveryTableView ) {
        return 125;
    }
    
    return 95;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     
    if (tableView == self.queueTableView)
    {
        QueueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"queueCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.startButton.tag = indexPath.row;
        Order * order = self.queueArray[indexPath.row];
        [cell setCellData:order];
        
        return cell;
    }
    else if(tableView == self.preparingTableView)
    {
        PreparingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"preparingCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.doneButton.tag = indexPath.row;
        Order * order = self.preparingArray[indexPath.row];
        [cell setCellData:order];
        
        return cell;
    }
    else if (tableView == self.outForDeliveryTableView)
    {
        OutForDeliveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"outForDeliveryCell" forIndexPath:indexPath];
        cell.delegate = self;
        Order * order = self.outForDeliveryArray[indexPath.row];
        [cell setCellData:order];
        
        return cell;
    }
    else if (tableView == self.readyToPickupTableView)
    {
        ReadyToPickUpTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"readyToPickUpCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.checkIconButton.tag = indexPath.row;
        Order * order = self.readyToPickUpArray[indexPath.row];
        [cell setCellData:order];
        
        return cell;
    }
    else if (tableView == self.completeTableView)
    {
        CompleteTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"completeCell" forIndexPath:indexPath];
        cell.delegate = self;
        Order * order = self.completeArray[indexPath.row];
        [cell setCellData:order];
        
        return cell;
    }
    else
    {
        SearchTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"searchOrderCell" forIndexPath:indexPath];
        cell.delegate = self;
        Order * order = self.searchArray[indexPath.row];
        [cell setCellData:order];
        return cell;
     }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailViewController * orderDetailViewController = [[OrderDetailViewController alloc]init];
    orderDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    orderDetailViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    orderDetailViewController.delegate = self;
    
    if (tableView == self.queueTableView)
    {
        orderDetailViewController.preferredContentSize = CGSizeMake(850, 670);
        orderDetailViewController.isQueue = TRUE;
        orderDetailViewController.isPreparing = FALSE;
        
        Order *order = _queueArray[indexPath.row];
        orderDetailViewController.order = order;
    }
    else if (tableView == self.preparingTableView)
    {
        orderDetailViewController.preferredContentSize = CGSizeMake(720, 580);
        orderDetailViewController.isQueue = FALSE;
        orderDetailViewController.isPreparing = TRUE;
        
        Order *order = _preparingArray[indexPath.row];
        orderDetailViewController.order = order;
    }
    else if (tableView == self.outForDeliveryTableView)
    {
        Order *order = _outForDeliveryArray[indexPath.row];
        orderDetailViewController.order = order;
        
        orderDetailViewController.preferredContentSize = CGSizeMake(720, 510);
        orderDetailViewController.isQueue = FALSE;
        orderDetailViewController.isPreparing = FALSE;
    }
    else if (tableView == self.readyToPickupTableView)
    {
        Order *order = _readyToPickUpArray[indexPath.row];
        orderDetailViewController.order = order;
         
        orderDetailViewController.preferredContentSize = CGSizeMake(720, 510);
        orderDetailViewController.isQueue = FALSE;
        orderDetailViewController.isPreparing = FALSE;
    }
    else if (tableView == self.completeTableView)
    {
        Order *order = _completeArray[indexPath.row];
        orderDetailViewController.order = order;
        orderDetailViewController.delegate = self;
        
        orderDetailViewController.preferredContentSize = CGSizeMake(720, 510);
        orderDetailViewController.isQueue = FALSE;
        orderDetailViewController.isPreparing = FALSE;
    }
    
    [self presentViewController: orderDetailViewController animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)initComponents
{
    [_containerView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"Orders";
    self.navigationItem.backBarButtonItem = backButton;
    
    self.queueArray = [[NSMutableArray alloc]init];
    self.preparingArray = [[NSMutableArray alloc]init];
    self.outForDeliveryArray = [[NSMutableArray alloc]init];
    self.readyToPickUpArray = [[NSMutableArray alloc]init];
    self.completeArray = [[NSMutableArray alloc]init];
    self.searchArray = [[NSMutableArray alloc]init];
    
    UILabel *queueLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 325, 20)];
    UILabel *preparingLabel = [[UILabel alloc]initWithFrame:CGRectMake(365, 50, 325, 20)];
    UILabel *outForDeliveryLabel = [[UILabel alloc]initWithFrame:CGRectMake(710, 50, 325, 20)];
    UILabel *readyForPickUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(1055, 50, 325, 20)];
    UILabel *completedLabel = [[UILabel alloc]initWithFrame:CGRectMake(1400, 50, 325, 20)];
    
    queueLabel.text = @"QUEUE";
    preparingLabel.text = @"PREPARING";
    outForDeliveryLabel.text = @"OUT FOR DELIVERY";
    readyForPickUpLabel.text = @"READY FOR PICKUP";
    completedLabel.text = @"COMPLETED";
    
    queueLabel.textColor = [UIColor colorWithRed:6.0/256.0 green:65.0/256.0 blue:97.0/256.0 alpha:1.0];
    preparingLabel.textColor = [UIColor colorWithRed:6.0/256.0 green:65.0/256.0 blue:97.0/256.0 alpha:1.0];
    outForDeliveryLabel.textColor = [UIColor colorWithRed:6.0/256.0 green:65.0/256.0 blue:97.0/256.0 alpha:1.0];
    readyForPickUpLabel.textColor = [UIColor colorWithRed:6.0/256.0 green:65.0/256.0 blue:97.0/256.0 alpha:1.0];
    completedLabel.textColor = [UIColor colorWithRed:6.0/256.0 green:65.0/256.0 blue:97.0/256.0 alpha:1.0];
    
    queueLabel.textAlignment = NSTextAlignmentCenter;
    preparingLabel.textAlignment = NSTextAlignmentCenter;
    outForDeliveryLabel.textAlignment = NSTextAlignmentCenter;
    readyForPickUpLabel.textAlignment = NSTextAlignmentCenter;
    completedLabel.textAlignment = NSTextAlignmentCenter;
    
    int containerHeight = _containerView.frame.size.height;
    _containerScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _containerView.frame.size.width, containerHeight)];
    _containerScrollView.contentSize = CGSizeMake(1745, containerHeight);
    _containerScrollView.backgroundColor = [UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:0.3];
    
    CGFloat currentVerticalOffset = _containerScrollView.contentOffset.x;
    CGFloat width = self.containerView.frame.size.width;
    
    self.queueTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 80, 325, containerHeight-120)];
    self.preparingTableView = [[UITableView alloc]initWithFrame:CGRectMake(365, 80, 325, containerHeight-120)];
    self.outForDeliveryTableView = [[UITableView alloc]initWithFrame:CGRectMake(710, 80, 325, containerHeight-120)];
    self.readyToPickupTableView = [[UITableView alloc]initWithFrame:CGRectMake(1055, 80, 325, containerHeight-120)];
    self.completeTableView = [[UITableView alloc]initWithFrame:CGRectMake(1400, 80, 325, containerHeight-120)];
    self.searchTableView = [[UITableView alloc]initWithFrame: CGRectMake(currentVerticalOffset + (width*0.125), 0, width*0.75, 300)];
    
    [_containerScrollView addSubview:queueLabel];
    [_containerScrollView addSubview:preparingLabel];
    [_containerScrollView addSubview:outForDeliveryLabel];
    [_containerScrollView addSubview:readyForPickUpLabel];
    [_containerScrollView addSubview:completedLabel];
    
    [_containerScrollView addSubview:_queueTableView];
    [_containerScrollView addSubview:_preparingTableView];
    [_containerScrollView addSubview:_outForDeliveryTableView];
    [_containerScrollView addSubview:_readyToPickupTableView];
    [_containerScrollView addSubview:_completeTableView];
    [_containerScrollView addSubview:_searchTableView];
    
    [_containerView addSubview:_containerScrollView];
    
    _queueTableView.layer.cornerRadius = 3;
    _queueTableView.layer.borderWidth = 1;
    _queueTableView.layer.borderColor = [[UIColor colorWithRed:204.0/256.0 green:204.0/256.0 blue:204.0/256.0 alpha:1.0]CGColor];
    _queueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _preparingTableView.layer.cornerRadius = 3;
    _preparingTableView.layer.borderWidth = 1;
    _preparingTableView.layer.borderColor = [[UIColor colorWithRed:204.0/256.0 green:204.0/256.0 blue:204.0/256.0 alpha:1.0]CGColor];
    _preparingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _readyToPickupTableView.layer.cornerRadius = 3;
    _readyToPickupTableView.layer.borderWidth = 1;
    _readyToPickupTableView.layer.borderColor = [[UIColor colorWithRed:204.0/256.0 green:204.0/256.0 blue:204.0/256.0 alpha:1.0]CGColor];
    _readyToPickupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _outForDeliveryTableView.layer.cornerRadius = 3;
    _outForDeliveryTableView.layer.borderWidth = 1;
    _outForDeliveryTableView.layer.borderColor = [[UIColor colorWithRed:204.0/256.0 green:204.0/256.0 blue:204.0/256.0 alpha:1.0]CGColor];
    _outForDeliveryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _completeTableView.layer.cornerRadius = 3;
    _completeTableView.layer.borderWidth = 1;
    _completeTableView.layer.borderColor = [[UIColor colorWithRed:204.0/256.0 green:204.0/256.0 blue:204.0/256.0 alpha:1.0]CGColor];
    _completeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _searchTableView.layer.cornerRadius = 3;
    _searchTableView.layer.borderWidth = 1;
    _searchTableView.layer.borderColor = [[UIColor colorWithRed:204.0/256.0 green:204.0/256.0 blue:204.0/256.0 alpha:1.0]CGColor];
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _queueTableView.delegate = self;
    _queueTableView.dataSource = self;
    _preparingTableView.delegate = self;
    _preparingTableView.dataSource = self;
    _outForDeliveryTableView.delegate = self;
    _outForDeliveryTableView.dataSource = self;
    _readyToPickupTableView.delegate = self;
    _readyToPickupTableView.dataSource = self;
    _completeTableView.delegate = self;
    _completeTableView.dataSource = self;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.hidden = TRUE;
    
    [self.queueTableView registerNib:[UINib nibWithNibName:@"QueueTableViewCell" bundle:nil] forCellReuseIdentifier:@"queueCell"];
    [self.preparingTableView registerNib:[UINib nibWithNibName:@"PreparingTableViewCell" bundle:nil] forCellReuseIdentifier:@"preparingCell"];
    [self.outForDeliveryTableView registerNib:[UINib nibWithNibName:@"OutForDeliveryTableViewCell" bundle:nil] forCellReuseIdentifier:@"outForDeliveryCell"];
    [self.readyToPickupTableView registerNib:[UINib nibWithNibName:@"ReadyToPickUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"readyToPickUpCell"];
    [self.completeTableView registerNib:[UINib nibWithNibName:@"CompleteTableViewCell" bundle:nil] forCellReuseIdentifier:@"completeCell"];
    [self.searchTableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchOrderCell"];
    
    [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(loadData) userInfo:nil repeats:YES];

}

-(void)loadData
{
    @try
    {
        [self getAllOrders];
        [self getFooterStatistics];
   
        [_queueTableView reloadData];
        [_preparingTableView reloadData];
        [_outForDeliveryTableView reloadData];
        [_readyToPickupTableView reloadData];
        [_completeTableView reloadData];
    }@catch(NSException *e)
    {
        NSLog(@"%@ %@", e.name, e.reason);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unable to Process, Please Login again" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                             {
                                 [super logout];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)getFooterStatistics
{
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?loc_id=%@&date=%@", Constants.FOOTER_STATISTICS_URL, Constants.LOCATION_ID, [Constants changeDateFormatForAPI: Constants.GET_TODAY_DATE] ]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    
    _pickedUp.text = [NSString stringWithFormat:@"%i", [[result objectForKey:@"pickedup"] intValue]];
    _delivered.text  = [NSString stringWithFormat:@"%i", [[result objectForKey:@"delivered"] intValue]];
    _outForDeliveryLabel.text = [NSString stringWithFormat:@"%i", [[result objectForKey:@"delivering"] intValue]];
    _totalOrders.text = [NSString stringWithFormat:@"%i of $%.2f", [[result objectForKey:@"totalOrders"] intValue], [[result objectForKey:@"totalPrice"] doubleValue]];
}

-(void)getAllOrders
{
    [_queueArray removeAllObjects];
    [_readyToPickUpArray removeAllObjects];
    [_outForDeliveryArray removeAllObjects];
    [_preparingArray removeAllObjects];
    [_completeArray removeAllObjects];
    
    NSURL *queueURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?status=1&loc_id=%@",Constants.GET_ALL_ORDERS_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData = [NSData dataWithContentsOfURL:queueURL];
    NSError *error = nil;
    NSDictionary *orderList = [NSJSONSerialization JSONObjectWithData:responseJSONData options:0 error:&error];
    NSDictionary *queuesDictionary = [orderList objectForKey:@"ordersList"];
    
    for (NSDictionary *queueDictionary in queuesDictionary)
    {
        NSString *orderId = [queueDictionary objectForKey:@"orderId"];
        NSString *orderDate = [self convertDate:[queueDictionary objectForKey:@"orderDate"]];
        NSString *orderTypeId = [[queueDictionary objectForKey:@"orderType"]objectForKey:@"orderTypeId"];
        NSString *quantity = [queueDictionary objectForKey:@"quantity"];
        NSString *estimatedTime = [queueDictionary objectForKey:@"estimatedTime"];
        NSString *customerName = [queueDictionary objectForKey:@"customerName"];
        NSString *customerPhone = [queueDictionary objectForKey:@"mobile"];
        
        Order * order = [[Order alloc]init];
        order.orderNo =  [NSString stringWithFormat: @"%@", orderId];
        order.customerName = customerName;
        order.contactNumber = customerPhone;
        order.orderTime = orderDate;
        order.timeRemain = [NSString stringWithFormat: @"%@", estimatedTime];
        order.itemCount = [NSString stringWithFormat: @"%@",quantity];
        order.status = @"Queue";
        order.deliveryType = [NSString stringWithFormat: @"%@",orderTypeId];
        
        [_queueArray addObject:order];
    }
    
    NSURL *preparingURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?status=2&loc_id=%@",Constants.GET_ALL_ORDERS_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData1 = [NSData dataWithContentsOfURL:preparingURL];
    orderList = [NSJSONSerialization JSONObjectWithData:responseJSONData1 options:0 error:&error];
    NSDictionary *preparingsDictionary = [orderList objectForKey:@"ordersList"];
    
    for (NSDictionary *preparingDictionary in preparingsDictionary)
    {
        NSString *orderId = [preparingDictionary objectForKey:@"orderId"];
        NSString *orderDate = [self convertDate: [preparingDictionary objectForKey:@"orderDate"]];
        NSString *orderTypeId = [[preparingDictionary objectForKey:@"orderType"]objectForKey:@"orderTypeId"];
        NSString *quantity = [preparingDictionary objectForKey:@"quantity"];
        NSString *estimatedTime = [preparingDictionary objectForKey:@"estimatedTime"];
        NSString *customerName = [preparingDictionary objectForKey:@"customerName"];
        NSString *customerPhone = [preparingDictionary objectForKey:@"mobile"];
        
        Order * order = [[Order alloc]init];
        order.orderNo =  [NSString stringWithFormat: @"%@", orderId];
        order.customerName = customerName;
        order.contactNumber = customerPhone;
        order.orderTime = orderDate;
        order.timeRemain = [NSString stringWithFormat: @"%@", estimatedTime];
        order.itemCount = [NSString stringWithFormat: @"%@",quantity];
        order.status = @"Preparing";
        order.deliveryType = [NSString stringWithFormat: @"%@",orderTypeId];
        
        [_preparingArray addObject:order];
    }
    
    NSURL *outForDeliveryURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?status=3&loc_id=%@",Constants.GET_ALL_ORDERS_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData2 = [NSData dataWithContentsOfURL:outForDeliveryURL];
    orderList = [NSJSONSerialization JSONObjectWithData:responseJSONData2 options:0 error:&error];
    NSDictionary *oFDsDictionary = [orderList objectForKey:@"ordersList"];
    
    for (NSDictionary *oFDDictionary in oFDsDictionary)
    {
        NSString *orderId = [oFDDictionary objectForKey:@"orderId"];
        NSString *orderDate = [oFDDictionary objectForKey:@"orderDate"];
        NSString *orderTypeId = [[oFDDictionary objectForKey:@"orderType"]objectForKey:@"orderTypeId"];
        NSString *quantity = [oFDDictionary objectForKey:@"quantity"];
        NSString *estimatedTime = [oFDDictionary objectForKey:@"estimatedTime"];
        NSString *customerName = [oFDDictionary objectForKey:@"customerName"];
        NSString *customerPhone = [oFDDictionary objectForKey:@"mobile"];
        NSString *dBoyName = [oFDDictionary objectForKey:@"deliveryboyName"];
        NSString *dBoyImage = [oFDDictionary objectForKey:@"deliveryboyImagURL"];
        
        Order * order = [[Order alloc]init];
        order.orderNo =  [NSString stringWithFormat: @"%@", orderId];
        order.customerName = customerName;
        order.contactNumber = customerPhone;
        order.orderTime = orderDate;
        order.timeRemain = [NSString stringWithFormat: @"%@", estimatedTime];
        order.itemCount = [NSString stringWithFormat: @"%@",quantity];
        order.status = @"Out For Delivery";
        order.deliveryType = [NSString stringWithFormat: @"%@",orderTypeId];
        order.deliveryPerson = dBoyName;
        order.deliveryPersonURL = dBoyImage;
        
        [_outForDeliveryArray addObject:order];
    }
    
    NSURL *readyToPickUpURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?status=4&loc_id=%@",Constants.GET_ALL_ORDERS_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData3 = [NSData dataWithContentsOfURL:readyToPickUpURL];
    orderList = [NSJSONSerialization JSONObjectWithData:responseJSONData3 options:0 error:&error];
    NSDictionary *rTPsDictionary = [orderList objectForKey:@"ordersList"];
    
    for (NSDictionary *rTPDictionary in rTPsDictionary)
    {
        NSString *orderId = [rTPDictionary objectForKey:@"orderId"];
        NSString *orderDate = [rTPDictionary objectForKey:@"orderDate"];
        NSString *orderTypeId = [[rTPDictionary objectForKey:@"orderType"] objectForKey:@"orderTypeId"];
        NSString *quantity = [rTPDictionary objectForKey:@"quantity"];
        NSString *estimatedTime = [rTPDictionary objectForKey:@"estimatedTime"];
        NSString *customerName = [rTPDictionary objectForKey:@"customerName"];
        NSString *customerPhone = [rTPDictionary objectForKey:@"mobile"];
        
        Order * order = [[Order alloc]init];
        order.orderNo =  [NSString stringWithFormat: @"%@", orderId];
        order.customerName = customerName;
        order.contactNumber = customerPhone;
        order.orderTime = orderDate;
        order.timeRemain = [NSString stringWithFormat: @"%@", estimatedTime];
        order.itemCount = [NSString stringWithFormat: @"%@",quantity];
        order.status = @"Ready To Pickup";
        order.deliveryType = [NSString stringWithFormat: @"%@",orderTypeId];
        
        [_readyToPickUpArray addObject:order];
    }
    
    NSURL *completedURL = [NSURL URLWithString: [NSString stringWithFormat:@"%@?status=6&loc_id=%@",Constants.GET_ALL_ORDERS_URL, Constants.LOCATION_ID]];
    NSData *responseJSONData4 = [NSData dataWithContentsOfURL:completedURL];
    orderList = [NSJSONSerialization JSONObjectWithData:responseJSONData4 options:0 error:&error];
    NSDictionary *completedDictionary = [orderList objectForKey:@"ordersList"];
    
    for (NSDictionary *cDictionary in completedDictionary)
    {
        NSString *orderId = [cDictionary objectForKey:@"orderId"];
        NSString *orderDate = [cDictionary objectForKey:@"orderDate"];
        NSString *orderTypeId = [[cDictionary objectForKey:@"orderType"]objectForKey:@"orderTypeId"];
        NSString *quantity = [cDictionary objectForKey:@"quantity"];
        NSString *estimatedTime = [cDictionary objectForKey:@"estimatedTime"];
        NSString *customerName = [cDictionary objectForKey:@"customerName"];
        NSString *customerPhone = [cDictionary objectForKey:@"mobile"];
        
        Order * order = [[Order alloc]init];
        order.orderNo =  [NSString stringWithFormat: @"%@", orderId];
        order.customerName = customerName;
        order.contactNumber = customerPhone;
        order.orderTime = orderDate;
        order.timeRemain = [NSString stringWithFormat: @"%@", estimatedTime];
        order.itemCount = [NSString stringWithFormat: @"%@",quantity];
        order.status = @"Completed";
        order.deliveryType = [NSString stringWithFormat: @"%@",orderTypeId];
        
        [_completeArray addObject:order];
    }
}

- (IBAction)searchTextChanged:(id)sender
{
    [_searchArray removeAllObjects];
    NSString *searchString = [Validation trim:_search.text];
    
    if([searchString length] == 0)
    {
        if ([_search.text isEqualToString:@" "])
        {
            _search.text = @"";
        }
        
        _searchTableView.hidden = YES;
        [_containerScrollView setScrollEnabled:YES];
    }
    else
    {
        for(Order *order in _queueArray)
        {
            if(order.customerName && [order.customerName rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [_searchArray addObject:order];
            }
            else if (order.orderNo && [order.orderNo caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
            else if (order.contactNumber && [order.contactNumber caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
        }
        
        for(Order *order in _preparingArray)
        {
            if(order.customerName && [order.customerName rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [_searchArray addObject:order];
            }
            else if (order.orderNo && [order.orderNo caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
            else if (order.contactNumber && [order.contactNumber caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
        }
        
        for(Order *order in _outForDeliveryArray)
        {
            if(order.customerName && [order.customerName rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [_searchArray addObject:order];
            }
            else if (order.orderNo && [order.orderNo caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
            else if (order.contactNumber && [order.contactNumber caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
        }
        
        for(Order *order in _readyToPickUpArray)
        {
            if(order.customerName && [order.customerName rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [_searchArray addObject:order];
            }
            else if (order.orderNo && [order.orderNo caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
            else if (order.contactNumber && [order.contactNumber caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
        }
        
        for(Order *order in _completeArray)
        {
            if(order.customerName && [order.customerName rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [_searchArray addObject:order];
            }
            else if (order.orderNo && [order.orderNo caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
            else if (order.contactNumber && [order.contactNumber caseInsensitiveCompare:searchString] == NSOrderedSame)
            {
                [_searchArray addObject:order];
            }
        }
        _searchTableView.hidden = NO;
        [_containerScrollView setScrollEnabled:YES];
        
    }
    
    [_searchTableView reloadData];
    
    if(_searchArray.count < 1)
    {
        _searchTableView.hidden = YES;
        [_containerScrollView setScrollEnabled:YES];
    }
    else
    {
        CGFloat currentVerticalOffset = _containerScrollView.contentOffset.x;
        CGFloat width = self.containerView.frame.size.width;
        CGFloat height = _searchArray.count * 95;
        if (height > 285) height = 285;
        _searchTableView.frame = CGRectMake(currentVerticalOffset + (width*0.125), 0, width*0.75, height);
    }
}

-(NSString *)convertDate:(NSString *) dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss.SS"];
    
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMM dd, HH:mm"];
    return [dateFormatter1 stringFromDate:dateFromString];
}

@end
